data "aws_iam_policy_document" "batch_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["batch.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "aws_batch_service_role" {
  name               = "${var.environment}-${var.aws_batch_service_role_name}"
  assume_role_policy = data.aws_iam_policy_document.batch_assume_role.json
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_security_group" "regov" {
  name = "${var.environment}-${var.aws_batch_compute_environment_security_group_name}"
  vpc_id = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_batch_compute_environment" "regov" {
  compute_environment_name = "${var.environment}-${var.compute_environment_name}"

  compute_resources {
    max_vcpus = 4

    security_group_ids = [
      aws_security_group.regov.id
    ]

    subnets = [
    var.private_subnets[0],
    var.private_subnets[1]
  ]

    type = "FARGATE"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
}

resource "aws_iam_role" "job_role" {
  name               = "${var.environment}-${var.job_role_name}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
      {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          }
      }
    ]
}
EOF
tags = {
    created-by = "terraform"
  }
}
# S3 read/write policy
resource "aws_iam_policy" "s3_policy" {
  name   = "${var.environment}-${var.batch_s3_policy_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "s3:*",
            "s3-object-lambda:*"
        ],
        "Resource": [
          "${var.src_bucket_domain_arn}",
          "${var.dst_bucket_domain_arn}/*"
        ]
    }
  ]
}
EOF
}
# Attach the policy to the job role
resource "aws_iam_role_policy_attachment" "job_policy_attachment" {
  role       = aws_iam_role.job_role.name
  policy_arn = aws_iam_policy.s3_policy.arn
}

resource "aws_batch_job_queue" "job_queue" {
  name     = "${var.environment}-${var.job_queue_name}"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    aws_batch_compute_environment.regov.arn
  ]
  depends_on = [aws_batch_compute_environment.regov]
tags = {
    created-by = "terraform"
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.environment}-${var.ecs_batch_exec_role}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_batch_job_definition" "job" {
  name = "${var.environment}-${var.regov_job_name}"
  type = "container"
  platform_capabilities = [
    "FARGATE",
  ]
  parameters = {}
  container_properties = jsonencode({
    command    = ["node", "app.js"]
    image      = "${var.ecr_repository_url}-${var.environment}"
    jobRoleArn = "${aws_iam_role.job_role.arn}"

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]

    environment = [
      {
        name  = "AWS_REGION"
        value = var.aws_region
      },
      {
        name  = "SRC_BUCKET"
        value = var.src_bucket_domain_name
      },
      {
        name  = "DST_BUCKET"
        value = var.dst_bucket_domain_name
      },
    ]

    executionRoleArn = aws_iam_role.ecs_task_execution_role.arn
  })
tags = {
    created-by = "terraform"
  }
}

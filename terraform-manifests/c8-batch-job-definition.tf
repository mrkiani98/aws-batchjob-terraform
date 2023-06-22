resource "aws_batch_job_queue" "job_queue" {
  name     = "job_queue"
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
  name               = "tf_test_batch_exec_role"
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
  name = "regov_job"
  type = "container"
  platform_capabilities = [
    "FARGATE",
  ]
  parameters = {}
  container_properties = jsonencode({
    command    = ["node", "app.js"]
    image      = aws_ecr_repository.kiani.repository_url
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
        value = aws_s3_bucket.input_bucket.bucket_domain_name
      },
      {
        name  = "DST_BUCKET"
        value = aws_s3_bucket.output_bucket.bucket_domain_name
      },
    ]

    executionRoleArn = aws_iam_role.ecs_task_execution_role.arn
  })
tags = {
    created-by = "terraform"
  }
}





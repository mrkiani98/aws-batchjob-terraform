resource "aws_iam_role" "cloudwatch_event_batch_job" {
  name               = "${var.environment}-${var.cloudwatch_event_batch_job_role_name}"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement":
    [
      {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Principal": {
            "Service": "events.amazonaws.com"
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
resource "aws_iam_policy" "cloudwatch_event_submit_batch" {
  name   = "${var.environment}-${var.cloudwatch_event_submit_batch_role_name}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "batch:*"
        ],
        "Resource": "*"
    }
  ]
}
EOF
}
# Attach the policy to the job role
resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  role       = aws_iam_role.cloudwatch_event_batch_job.name
  policy_arn = aws_iam_policy.cloudwatch_event_submit_batch.arn
}


resource "aws_cloudwatch_event_target" "test-scheduled-job" {
  target_id = "${var.environment}-${var.project_name}"
  rule      = "${aws_cloudwatch_event_rule.regov-rule.name}"
  arn       = "${var.job_queue_arn}"
  role_arn  = "${aws_iam_role.cloudwatch_event_batch_job.arn}"
  batch_target {
    job_name       = "${var.environment}-${var.project_name}"
    job_definition = "${var.batch_job_id}"
  }
}

resource "aws_cloudwatch_event_rule" "regov-rule" {
  name                = "cw-rule"
  description         = "Cron job to read data from S3 and put it in another S3"
  schedule_expression = "cron(0/1 * * * ? *)"
}
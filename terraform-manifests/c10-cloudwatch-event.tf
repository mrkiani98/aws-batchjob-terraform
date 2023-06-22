resource "aws_cloudwatch_event_target" "test-scheduled-job" {
  target_id = "regov-target"
  rule      = "${aws_cloudwatch_event_rule.regov-rule.name}"
  arn       = "${aws_batch_job_queue.job_queue.arn}"
  role_arn  = "${aws_iam_role.cloudwatch_event_batch_job.arn}"
  batch_target {
    job_name       = "regov-batch-job"
    job_definition = "${aws_batch_job_definition.job.id}"
  }
}

resource "aws_cloudwatch_event_rule" "regov-rule" {
  name                = "cw-rule"
  description         = "Cron job to read data from S3 and put it in another S3"
  schedule_expression = "cron(0/1 * * * ? *)"
}
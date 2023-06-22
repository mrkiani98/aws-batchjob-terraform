resource "aws_iam_role" "cloudwatch_event_batch_job" {
  name               = "cloudwatch_event_batch_job"
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
  name   = "cloudwatch_event_submit_batch"
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
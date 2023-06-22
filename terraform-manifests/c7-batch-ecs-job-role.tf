resource "aws_iam_role" "job_role" {
  name               = "job_role"
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
  name   = "s3_policy"
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
          "${aws_s3_bucket.input_bucket.arn}",
          "${aws_s3_bucket.output_bucket.arn}/*"
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
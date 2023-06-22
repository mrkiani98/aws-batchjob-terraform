resource "aws_s3_bucket" "input_bucket" {
  bucket = "regov-input-bucket"

  tags = local.common_tags
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = "regov-output-bucket"

  tags = local.common_tags
}
resource "aws_s3_bucket" "input_bucket" {
  bucket = "${var.environment}-${var.source_bucket}"

  # tags = local.common_tags
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = "${var.environment}-${var.dst_bucket}"

  # tags = local.common_tags
}
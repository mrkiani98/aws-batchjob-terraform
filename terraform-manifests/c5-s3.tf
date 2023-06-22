resource "aws_s3_bucket" "input_bucket" {
  bucket = "src-kiani"

  tags = local.common_tags
}

resource "aws_s3_bucket" "output_bucket" {
  bucket = "dst-kiani"

  tags = local.common_tags
}
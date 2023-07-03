output "src_bucket_domain_name" {
  description = "The name of the src bucket"
  value       = aws_s3_bucket.input_bucket.bucket_domain_name
}

output "dst_bucket_domain_name" {
  description = "The name of the dst bucket"
  value       = aws_s3_bucket.output_bucket.bucket_domain_name
}

output "src_bucket_domain_arn" {
  description = "The arn of src bucket"
  value       = aws_s3_bucket.input_bucket.arn
}

output "dst_bucket_domain_arn" {
  description = "The arn of dst bucket"
  value       = aws_s3_bucket.output_bucket.arn
}
output "repository_url" {
  description = "The URL of ecr"
  value       = aws_ecr_repository.kiani.repository_url
}
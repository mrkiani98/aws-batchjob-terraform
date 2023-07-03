output "job_queue_arn" {
  description = "The batch job queue arn"
  value       = aws_batch_job_queue.job_queue.arn
}

output "batch_job_id" {
  description = "The batch job id"
  value       = aws_batch_job_definition.job.id
}
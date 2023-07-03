variable "vpc_id" {}
variable "private_subnets" {}
variable "ecr_repository_url" {}
variable "src_bucket_domain_name" {}
variable "dst_bucket_domain_name" {}
variable "src_bucket_domain_arn" {}
variable "dst_bucket_domain_arn" {}
variable "aws_region" {}
variable "environment" {}
variable "aws_batch_service_role_name" {}
variable "aws_batch_compute_environment_security_group_name" {}
variable "compute_environment_name" {}
variable "job_role_name" {}
variable "batch_s3_policy_name" {}
variable "job_queue_name" {}
variable "ecs_batch_exec_role" {}
variable "regov_job_name" {}
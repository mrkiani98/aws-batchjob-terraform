# VPC Input Variables

# VPC Name
variable "vpc_name" {}

# VPC CIDR Block
variable "vpc_cidr_block" {}

# VPC Availability Zones
# variable "vpc_availability_zones" {}

# VPC Public Subnets
variable "vpc_public_subnets" {}

# VPC Private Subnets
variable "vpc_private_subnets" {}

# VPC Enable NAT Gateway (True or False) 
variable "vpc_enable_nat_gateway" {}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {}

variable "aws_region" {}

variable "s3_source_bucket" {}
variable "s3_dst_bucket" {}
variable "environment" {}

variable "cloudwatch_event_batch_job_role_name" {}
variable "cloudwatch_event_submit_batch_role_name" {}
variable "project_name" {}

variable "aws_batch_service_role_name" {}
variable "aws_batch_compute_environment_security_group_name" {}
variable "compute_environment_name" {}
variable "job_role_name" {}
variable "batch_s3_policy_name" {}
variable "job_queue_name" {}
variable "ecs_batch_exec_role" {}
variable "regov_job_name" {}


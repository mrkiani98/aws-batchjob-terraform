
# creating VPC
module "vpc" {
  source           = "../modules/vpc"
  vpc_name           = var.vpc_name
  vpc_cidr_block     = var.vpc_cidr_block
#   vpc_availability_zones         = var.vpc_availability_zones
  vpc_public_subnets = var.vpc_public_subnets
  vpc_private_subnets = var.vpc_private_subnets
  vpc_enable_nat_gateway = var.vpc_enable_nat_gateway
  vpc_single_nat_gateway = var.vpc_single_nat_gateway
}


# cretea ECR
module "ecr" {
  source = "../modules/ecr"
}


# create s3 buckets 
module "s3" {
  source = "../modules/s3"
  source_bucket = var.s3_source_bucket
  dst_bucket = var.s3_dst_bucket
  environment = var.environment
}

# create batch job
module "batchJob" {
  source = "../modules/batch_job"
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  ecr_repository_url = module.ecr.repository_url
  src_bucket_domain_name = module.s3.src_bucket_domain_name
  dst_bucket_domain_name = module.s3.dst_bucket_domain_name
  src_bucket_domain_arn = module.s3.src_bucket_domain_arn
  dst_bucket_domain_arn = module.s3.dst_bucket_domain_arn
  aws_region = var.aws_region
  environment = var.environment
  aws_batch_service_role_name = var.aws_batch_service_role_name
  aws_batch_compute_environment_security_group_name = var.aws_batch_compute_environment_security_group_name
  compute_environment_name = var.compute_environment_name
  job_role_name = var.job_role_name
  batch_s3_policy_name = var.batch_s3_policy_name
  job_queue_name = var.job_queue_name
  ecs_batch_exec_role = var.ecs_batch_exec_role
  regov_job_name = var.regov_job_name
}

# create batch job
module "cloudwatch" {
  source = "../modules/cloudwatch"
  job_queue_arn = module.batchJob.job_queue_arn
  batch_job_id = module.batchJob.batch_job_id
  cloudwatch_event_batch_job_role_name = var.cloudwatch_event_batch_job_role_name
  cloudwatch_event_submit_batch_role_name = var.cloudwatch_event_submit_batch_role_name
  project_name = var.project_name
  environment = var.environment
}


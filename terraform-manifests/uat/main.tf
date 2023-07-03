data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket  = "kiani-terraform-state"
    region  = "ap-southeast-1"
    encrypt = false

    # dynamodb_table = "tfstates-lock-TABLE_THAT_DOES_NOT_EXIST"
    key            = "dev/terraform/terraform.tfstate"
  }
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
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
  private_subnets = data.terraform_remote_state.vpc.outputs.private_subnets
  ecr_repository_url = data.terraform_remote_state.vpc.outputs.repository_url
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


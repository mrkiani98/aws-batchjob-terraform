# aws-batchjob-terraform

## Solution explanation

* Setup a separate VPC with public and private subnet with NAT gateway enabled
* Setup desired IAM roles for batch job compute environment and batch job execution
* Setup a cronjob expression by leveraging cloudwatch events to trigger the batch job
* Custom nodejs script to read and copy files from source s3 bucket to a destination bucket ( The logic of the nodejs script is so simple and just for demonstration)
* Using github action for the CI/CD pipeline to build the docker image from the src source code and push it AWS ECR and also apply terraform manifests

### Solution for setup multiple environment with terraform

* Using sub-modules and reuse them in multiple environments (Not using terraform workspaces)
* Using prod envirnments vpc and ecr modules in other environment to avoid duplicates
* Using sub-modules outputs and reuse it in other modules to create multiple environments
* Listening on different branches in github and build the code with related tag name and use it in related environment
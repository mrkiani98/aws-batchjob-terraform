# aws-batchjob-terraform

## Solution explanation

* Setup a separate VPC with public and private subnet with NAT gateway enabled
* Setup desired IAM roles for batch job compute environment and batch job execution
* Setup a cronjob expression by leveraging cloudwatch events to trigger the batch job
* Custom nodejs script to read and copy files from source s3 bucket to a destination bucket ( The logic of the nodejs script is so simple and just for demonstration)
* Using github action for the CI/CD pipeline to build the docker image from the src source code and push it AWS ECR and also apply terraform manifests
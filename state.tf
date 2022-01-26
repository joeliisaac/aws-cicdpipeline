
// set up backup on s3 bucket to store state file
terraform {
  backend "s3" {
    bucket  = "aws-sandbox-cicd-pipeline"
    encrypt = true
    key     = "terraform.tfstate"
    region  = "us-east-1"

  }
}
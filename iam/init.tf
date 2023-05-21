terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }

  // This stores the terraform state in an S3 bucket
  backend "s3" {
    bucket = "company-tf-state"
    // The path to our state file in the bucket
    key    = "iam/terraform.tfstate"
    region = "us-east-1"
    // DynamoDB is used to prevent concurrent writes to the state file
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

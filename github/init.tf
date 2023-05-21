terraform {
  required_version = ">= 1.4.4"

  required_providers {
    // The AWS provider is required for backend state storage/locking
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.63.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }

  // This stores the terraform state in an S3 bucket
  backend "s3" {
    bucket = "company-tf-state"
    // The path to our state file in the bucket
    key    = "github/terraform.tfstate"
    region = "us-east-1"
    // DynamoDB is used to prevent concurrent writes to the state file
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {
  owner = "your-github-org"
  // We use a github app for authentication
  app_auth {
    id              = "12345"
    installation_id = "67890"
    pem_file        = file("/path/to/github-certs.pem")
  }
}

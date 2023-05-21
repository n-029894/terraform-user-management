terraform {
  required_version = ">= 1.4.0"

  required_providers {
    // The AWS provider is required for backend state storage/locking
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
    googleworkspace = {
      source  = "hashicorp/googleworkspace"
      version = ">= 0.7.0"
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

// Using a service account to authenticate to the Google Workspace API
provider "googleworkspace" {
  // The credentials file is generated for the specific service account you
  // will be using.
  credentials = "/path/to/credentials.json"
  customer_id = "1234567890"
  oauth_scopes = [
    "https://www.googleapis.com/auth/admin.directory.user",
    "https://www.googleapis.com/auth/admin.directory.userschema",
  ]
}

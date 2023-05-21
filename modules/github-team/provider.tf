// Github requires the provider configuration to be included in the module as
// well as the root directory
terraform {
  required_version = ">= 1.4.4"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
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

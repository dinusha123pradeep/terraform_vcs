terraform {
  cloud {
    organization = "marathunga"
    workspaces {
      name = "terraform_vcs"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.35.0"
    }
  }

  required_version = ">=1.3.0"
}
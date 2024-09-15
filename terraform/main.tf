terraform {
  required_version = "1.9.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.67.0"
    }
    github = {
      source  = "integrations/github"
      version = "6.3.0"
    }
  }
  backend "s3" {
    region               = "us-east-1"
    dynamodb_table       = "tf-ryanemcdaniel-management-lock"
    bucket               = "tf-ryanemcdaniel-management"
    workspace_key_prefix = ""
    key                  = "dffp/aws-github.tfstate"
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      comp = "org"
      env  = "org"
      git  = "git@github.com:deep-fried-family-planning/aws-organization.git"
    }
  }
}

provider "github" {
  owner = "deep-fried-family-planning"
}

data "aws_ssm_parameter" "gh_org_email" {
  name = "/DFFP/GITHUB_ORG/EMAIL"
}

data "github_organization" "dffp" {
  name = "deep-fried-family-planning"
}

locals {
  ryanemcdaniel = data.github_user.users["ryanemcdaniel"]
}
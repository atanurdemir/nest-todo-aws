locals {
  region = "eu-west-1"
}

provider "aws" {
  region              = local.region
  allowed_account_ids = [var.allowed_account_ids]
}

terraform {
  required_version = "1.3.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.54.0"
    }
  }
  backend "s3" {}
}
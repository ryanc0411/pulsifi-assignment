terraform {
  required_version = ">= 1.0, < 2.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = var.aws_cloud_creds.access_key
  secret_key = var.aws_cloud_creds.secret_key
}
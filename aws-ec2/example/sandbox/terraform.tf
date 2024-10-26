terraform {
  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "aws-ec2-s3-backend"
    key            = "aws-ec2/sandbox/terraform.tfstate"
    encrypt        = true
    dynamodb_table = "aws-ec2-s3-backend"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

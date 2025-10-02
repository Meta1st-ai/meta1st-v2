terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "metafirst-terraform-state-335080625271"
    key            = "prod/cognito/terraform.tfstate"
    region         = "eu-west-1"
    acl            = "bucket-owner-full-control"
    dynamodb_table = "metafirst-terraform-locks"
  }
}

provider "aws" {
  region = var.aws_region
}
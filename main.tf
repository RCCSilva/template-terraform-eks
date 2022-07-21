terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.21"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "sa-east-1"
}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_region" "current" {}

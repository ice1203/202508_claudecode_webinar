terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
  }
  required_version = ">= 1.7"

  backend "s3" {
    bucket  = "web3-todo-app-terraform-state"
    key     = "dev/services/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Component   = "services"
      ManagedBy   = "terraform"
    }
  }
}
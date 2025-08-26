# Terraform configuration and provider requirements

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
  }

  backend "s3" {
    bucket  = "web3-todo-app-terraform-state"
    key     = "dev/monitoring/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}

# AWS Provider configuration
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = merge(
      {
        Environment = var.environment
        Project     = var.project_name
        Component   = "monitoring"
        ManagedBy   = "terraform"
      },
      var.tags
    )
  }
}
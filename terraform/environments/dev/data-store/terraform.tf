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
    key     = "dev/data-store/terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}
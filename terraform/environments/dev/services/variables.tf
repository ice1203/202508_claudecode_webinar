variable "aws_region" {
  type        = string
  description = "AWS region for resource deployment"
  default     = "ap-northeast-1"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "dev"
}

variable "project_name" {
  type        = string
  description = "Project name for resource tagging"
  default     = "web3-todo-app"
}

variable "prefix" {
  type        = string
  description = "Prefix for resource names"
  default     = "web3-todo-dev"

  validation {
    condition     = length(var.prefix) > 0 && length(var.prefix) <= 20
    error_message = "Prefix must be between 1 and 20 characters."
  }
}

variable "lambda_runtime" {
  type        = string
  description = "Lambda runtime version"
  default     = "python3.9"

  validation {
    condition     = contains(["python3.9", "nodejs18.x"], var.lambda_runtime)
    error_message = "Lambda runtime must be either python3.9 or nodejs18.x."
  }
}

variable "lambda_timeout" {
  type        = number
  description = "Lambda function timeout in seconds"
  default     = 30

  validation {
    condition     = var.lambda_timeout > 0 && var.lambda_timeout <= 900
    error_message = "Lambda timeout must be between 1 and 900 seconds."
  }
}

variable "api_gateway_stage_name" {
  type        = string
  description = "API Gateway stage name"
  default     = "v1"

  validation {
    condition     = length(var.api_gateway_stage_name) > 0
    error_message = "API Gateway stage name must not be empty."
  }
}

variable "cors_allowed_origins" {
  type        = list(string)
  description = "List of allowed origins for CORS"
  default     = ["*"]
}

variable "cors_allowed_methods" {
  type        = list(string)
  description = "List of allowed HTTP methods for CORS"
  default     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
}

variable "cors_allowed_headers" {
  type        = list(string)
  description = "List of allowed headers for CORS"
  default     = ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token"]
}

variable "data_store_state_bucket" {
  type        = string
  description = "S3 bucket name for data-store state"
  default     = "web3-todo-app-terraform-state"
}

variable "data_store_state_key" {
  type        = string
  description = "S3 key for data-store state"
  default     = "dev/data-store/terraform.tfstate"
}
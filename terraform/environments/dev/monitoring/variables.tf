# Input variables for monitoring resources

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = can(regex("^(dev|staging|prod)$", var.environment))
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "project_name" {
  type        = string
  description = "Name of the project"
  default     = "web3-todo-app"

  validation {
    condition     = length(var.project_name) > 0
    error_message = "Project name must not be empty."
  }
}

variable "prefix" {
  type        = string
  description = "Resource naming prefix combining project and environment"
  default     = "web3-todo-dev"

  validation {
    condition     = length(var.prefix) > 0 && length(var.prefix) <= 32
    error_message = "Prefix must be between 1 and 32 characters."
  }
}

variable "log_retention_days" {
  type        = number
  description = "Number of days to retain CloudWatch logs"
  default     = 7

  validation {
    condition = contains([
      1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653
    ], var.log_retention_days)
    error_message = "Log retention days must be a valid CloudWatch retention period."
  }
}

variable "kms_key_id" {
  type        = string
  description = "KMS key ID for CloudWatch log encryption (optional)"
  default     = null
  sensitive   = false

  validation {
    condition     = var.kms_key_id == null || can(regex("^(arn:aws:kms:|alias/)", var.kms_key_id))
    error_message = "KMS key ID must be either a KMS key ARN or alias, or null."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region for resources"
  default     = "ap-northeast-1"

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "AWS region must be in valid format (e.g., ap-northeast-1)."
  }
}

variable "tags" {
  type        = map(string)
  description = "Additional tags to apply to all resources"
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) > 0 && length(v) > 0])
    error_message = "All tag keys and values must be non-empty strings."
  }
}
variable "aws_region" {
  type        = string
  description = "AWS region for resource deployment"
  default     = "ap-northeast-1"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "AWS region must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  type        = string
  description = "Environment name (dev, staging, prod)"
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming and tagging"
  default     = "web3-todo-app"

  validation {
    condition     = length(var.project_name) > 0 && length(var.project_name) <= 50
    error_message = "Project name must be between 1 and 50 characters."
  }
}

variable "read_capacity" {
  type        = number
  description = "DynamoDB table read capacity units"
  default     = 5

  validation {
    condition     = var.read_capacity >= 1 && var.read_capacity <= 100
    error_message = "Read capacity must be between 1 and 100."
  }
}

variable "write_capacity" {
  type        = number
  description = "DynamoDB table write capacity units"
  default     = 5

  validation {
    condition     = var.write_capacity >= 1 && var.write_capacity <= 100
    error_message = "Write capacity must be between 1 and 100."
  }
}

variable "kms_key_deletion_window" {
  type        = number
  description = "KMS key deletion window in days"
  default     = 7

  validation {
    condition     = var.kms_key_deletion_window >= 7 && var.kms_key_deletion_window <= 30
    error_message = "KMS key deletion window must be between 7 and 30 days."
  }
}

variable "backup_retention_period" {
  type        = number
  description = "DynamoDB backup retention period in days"
  default     = 7

  validation {
    condition     = var.backup_retention_period >= 1 && var.backup_retention_period <= 35
    error_message = "Backup retention period must be between 1 and 35 days."
  }
}

variable "enable_point_in_time_recovery" {
  type        = bool
  description = "Enable point-in-time recovery for DynamoDB table"
  default     = true
}

variable "enable_encryption" {
  type        = bool
  description = "Enable encryption at rest for DynamoDB table"
  default     = true
}
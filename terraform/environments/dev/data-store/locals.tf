locals {
  # Resource naming convention
  prefix = "${var.project_name}-${var.environment}"

  # Common tags for all resources
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
    Component   = "data-store"
    ManagedBy   = "terraform"
  }

  # DynamoDB table configuration
  table_name = "${local.prefix}-todo-items"

  # IAM role and policy names
  dynamodb_role_name   = "${local.prefix}-dynamodb-role"
  dynamodb_policy_name = "${local.prefix}-dynamodb-policy"

  # KMS key alias
  kms_key_alias = "alias/${local.prefix}-dynamodb-key"
}
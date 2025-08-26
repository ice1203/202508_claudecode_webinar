output "dynamodb_table_name" {
  description = "Name of the DynamoDB table for todo items"
  value       = aws_dynamodb_table.todo_items.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table for todo items"
  value       = aws_dynamodb_table.todo_items.arn
}

output "dynamodb_table_id" {
  description = "ID of the DynamoDB table for todo items"
  value       = aws_dynamodb_table.todo_items.id
}

output "dynamodb_table_stream_arn" {
  description = "Stream ARN of the DynamoDB table (if enabled)"
  value       = aws_dynamodb_table.todo_items.stream_arn
}

output "iam_role_arn" {
  description = "ARN of the IAM role for DynamoDB access"
  value       = aws_iam_role.dynamodb_role.arn
}

output "iam_role_name" {
  description = "Name of the IAM role for DynamoDB access"
  value       = aws_iam_role.dynamodb_role.name
}

output "kms_key_arn" {
  description = "ARN of the KMS key for DynamoDB encryption"
  value       = var.enable_encryption ? aws_kms_key.dynamodb[0].arn : null
}

output "kms_key_id" {
  description = "ID of the KMS key for DynamoDB encryption"
  value       = var.enable_encryption ? aws_kms_key.dynamodb[0].key_id : null
}

output "kms_key_alias" {
  description = "Alias of the KMS key for DynamoDB encryption"
  value       = var.enable_encryption ? aws_kms_alias.dynamodb[0].name : null
}

output "environment" {
  description = "Environment name"
  value       = var.environment
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}
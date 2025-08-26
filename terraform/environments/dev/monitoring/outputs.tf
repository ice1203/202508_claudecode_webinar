# Output values for monitoring resources

# API Gateway Log Group
output "api_gateway_log_group_arn" {
  description = "ARN of the API Gateway CloudWatch log group"
  value       = aws_cloudwatch_log_group.api_gateway_logs.arn
  sensitive   = false
}

output "api_gateway_log_group_name" {
  description = "Name of the API Gateway CloudWatch log group"
  value       = aws_cloudwatch_log_group.api_gateway_logs.name
  sensitive   = false
}

# Lambda Log Groups
output "lambda_create_todo_log_group_arn" {
  description = "ARN of the Create Todo Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_create_todo_logs.arn
  sensitive   = false
}

output "lambda_create_todo_log_group_name" {
  description = "Name of the Create Todo Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_create_todo_logs.name
  sensitive   = false
}

output "lambda_get_todos_log_group_arn" {
  description = "ARN of the Get Todos Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_get_todos_logs.arn
  sensitive   = false
}

output "lambda_get_todos_log_group_name" {
  description = "Name of the Get Todos Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_get_todos_logs.name
  sensitive   = false
}

output "lambda_update_todo_log_group_arn" {
  description = "ARN of the Update Todo Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_update_todo_logs.arn
  sensitive   = false
}

output "lambda_update_todo_log_group_name" {
  description = "Name of the Update Todo Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_update_todo_logs.name
  sensitive   = false
}

output "lambda_delete_todo_log_group_arn" {
  description = "ARN of the Delete Todo Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_delete_todo_logs.arn
  sensitive   = false
}

output "lambda_delete_todo_log_group_name" {
  description = "Name of the Delete Todo Lambda CloudWatch log group"
  value       = aws_cloudwatch_log_group.lambda_delete_todo_logs.name
  sensitive   = false
}

# Log Groups Map for easy reference
output "log_groups" {
  description = "Map of all log group names and ARNs"
  value = {
    api_gateway = {
      name = aws_cloudwatch_log_group.api_gateway_logs.name
      arn  = aws_cloudwatch_log_group.api_gateway_logs.arn
    }
    lambda_create_todo = {
      name = aws_cloudwatch_log_group.lambda_create_todo_logs.name
      arn  = aws_cloudwatch_log_group.lambda_create_todo_logs.arn
    }
    lambda_get_todos = {
      name = aws_cloudwatch_log_group.lambda_get_todos_logs.name
      arn  = aws_cloudwatch_log_group.lambda_get_todos_logs.arn
    }
    lambda_update_todo = {
      name = aws_cloudwatch_log_group.lambda_update_todo_logs.name
      arn  = aws_cloudwatch_log_group.lambda_update_todo_logs.arn
    }
    lambda_delete_todo = {
      name = aws_cloudwatch_log_group.lambda_delete_todo_logs.name
      arn  = aws_cloudwatch_log_group.lambda_delete_todo_logs.arn
    }
  }
  sensitive = false
}
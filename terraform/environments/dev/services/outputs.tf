# API Gateway outputs
output "api_gateway_rest_api_id" {
  description = "ID of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.todo_api.id
}

output "api_gateway_rest_api_name" {
  description = "Name of the API Gateway REST API"
  value       = aws_api_gateway_rest_api.todo_api.name
}

output "api_gateway_deployment_id" {
  description = "ID of the API Gateway deployment"
  value       = aws_api_gateway_deployment.todo_api_deployment.id
}

output "api_gateway_stage_name" {
  description = "Stage name of the API Gateway deployment"
  value       = var.api_gateway_stage_name
}

output "api_gateway_invoke_url" {
  description = "Base URL for API Gateway stage"
  value       = "https://${aws_api_gateway_rest_api.todo_api.id}.execute-api.${var.aws_region}.amazonaws.com/${var.api_gateway_stage_name}"
}

output "api_gateway_todos_endpoint" {
  description = "Full URL for the todos endpoint"
  value       = "https://${aws_api_gateway_rest_api.todo_api.id}.execute-api.${var.aws_region}.amazonaws.com/${var.api_gateway_stage_name}/todos"
}

# Lambda function outputs
output "lambda_get_todos_function_name" {
  description = "Name of the get todos Lambda function"
  value       = aws_lambda_function.get_todos.function_name
}

output "lambda_get_todos_arn" {
  description = "ARN of the get todos Lambda function"
  value       = aws_lambda_function.get_todos.arn
}

output "lambda_create_todo_function_name" {
  description = "Name of the create todo Lambda function"
  value       = aws_lambda_function.create_todo.function_name
}

output "lambda_create_todo_arn" {
  description = "ARN of the create todo Lambda function"
  value       = aws_lambda_function.create_todo.arn
}

output "lambda_update_todo_function_name" {
  description = "Name of the update todo Lambda function"
  value       = aws_lambda_function.update_todo.function_name
}

output "lambda_update_todo_arn" {
  description = "ARN of the update todo Lambda function"
  value       = aws_lambda_function.update_todo.arn
}

output "lambda_delete_todo_function_name" {
  description = "Name of the delete todo Lambda function"
  value       = aws_lambda_function.delete_todo.function_name
}

output "lambda_delete_todo_arn" {
  description = "ARN of the delete todo Lambda function"
  value       = aws_lambda_function.delete_todo.arn
}

# IAM role outputs
output "lambda_execution_role_name" {
  description = "Name of the Lambda execution IAM role"
  value       = aws_iam_role.lambda_execution_role.name
}

output "lambda_execution_role_arn" {
  description = "ARN of the Lambda execution IAM role"
  value       = aws_iam_role.lambda_execution_role.arn
}

# CloudWatch Log Groups outputs
output "cloudwatch_log_group_get_todos" {
  description = "Name of the CloudWatch log group for get todos function"
  value       = aws_cloudwatch_log_group.lambda_get_todos.name
}

output "cloudwatch_log_group_create_todo" {
  description = "Name of the CloudWatch log group for create todo function"
  value       = aws_cloudwatch_log_group.lambda_create_todo.name
}

output "cloudwatch_log_group_update_todo" {
  description = "Name of the CloudWatch log group for update todo function"
  value       = aws_cloudwatch_log_group.lambda_update_todo.name
}

output "cloudwatch_log_group_delete_todo" {
  description = "Name of the CloudWatch log group for delete todo function"
  value       = aws_cloudwatch_log_group.lambda_delete_todo.name
}

# Data store connection info
output "connected_dynamodb_table_name" {
  description = "Name of the DynamoDB table connected to Lambda functions"
  value       = data.terraform_remote_state.data_store.outputs.dynamodb_table_name
}

output "connected_dynamodb_table_arn" {
  description = "ARN of the DynamoDB table connected to Lambda functions"
  value       = data.terraform_remote_state.data_store.outputs.dynamodb_table_arn
}
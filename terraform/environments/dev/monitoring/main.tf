# CloudWatch Log Groups for Web3 Todo Application - Dev Environment

# API Gateway Access Logs
resource "aws_cloudwatch_log_group" "api_gateway_logs" {
  name              = "/aws/apigateway/${var.project_name}-${var.environment}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${var.prefix}-api-gateway-logs"
    Environment = var.environment
    Project     = var.project_name
    Component   = "monitoring"
    LogType     = "api-gateway"
  }
}

# Lambda Function Logs - Create Todo
resource "aws_cloudwatch_log_group" "lambda_create_todo_logs" {
  name              = "/aws/lambda/${var.prefix}-create-todo"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${var.prefix}-lambda-create-todo-logs"
    Environment = var.environment
    Project     = var.project_name
    Component   = "monitoring"
    LogType     = "lambda"
    Function    = "create-todo"
  }
}

# Lambda Function Logs - Get Todos
resource "aws_cloudwatch_log_group" "lambda_get_todos_logs" {
  name              = "/aws/lambda/${var.prefix}-get-todos"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${var.prefix}-lambda-get-todos-logs"
    Environment = var.environment
    Project     = var.project_name
    Component   = "monitoring"
    LogType     = "lambda"
    Function    = "get-todos"
  }
}

# Lambda Function Logs - Update Todo
resource "aws_cloudwatch_log_group" "lambda_update_todo_logs" {
  name              = "/aws/lambda/${var.prefix}-update-todo"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${var.prefix}-lambda-update-todo-logs"
    Environment = var.environment
    Project     = var.project_name
    Component   = "monitoring"
    LogType     = "lambda"
    Function    = "update-todo"
  }
}

# Lambda Function Logs - Delete Todo
resource "aws_cloudwatch_log_group" "lambda_delete_todo_logs" {
  name              = "/aws/lambda/${var.prefix}-delete-todo"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.kms_key_id

  tags = {
    Name        = "${var.prefix}-lambda-delete-todo-logs"
    Environment = var.environment
    Project     = var.project_name
    Component   = "monitoring"
    LogType     = "lambda"
    Function    = "delete-todo"
  }
}
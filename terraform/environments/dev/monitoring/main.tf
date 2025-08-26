# CloudWatch Log Groups for Web3 Todo Application - Dev Environment
# Note: Lambda log groups are created in the services module to avoid conflicts

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
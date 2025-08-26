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

# Log Groups Map for easy reference
output "log_groups" {
  description = "Map of all log group names and ARNs"
  value = {
    api_gateway = {
      name = aws_cloudwatch_log_group.api_gateway_logs.name
      arn  = aws_cloudwatch_log_group.api_gateway_logs.arn
    }
  }
  sensitive = false
}
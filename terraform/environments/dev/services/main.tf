# Data source to retrieve data-store state outputs
data "terraform_remote_state" "data_store" {
  backend = "s3"
  config = {
    bucket = var.data_store_state_bucket
    key    = var.data_store_state_key
    region = var.aws_region
  }
}

# CloudWatch Log Groups for Lambda functions
resource "aws_cloudwatch_log_group" "lambda_get_todos" {
  name              = "/aws/lambda/${var.prefix}-get-todos"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "lambda_create_todo" {
  name              = "/aws/lambda/${var.prefix}-create-todo"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "lambda_update_todo" {
  name              = "/aws/lambda/${var.prefix}-update-todo"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_group" "lambda_delete_todo" {
  name              = "/aws/lambda/${var.prefix}-delete-todo"
  retention_in_days = 14
}

# IAM role for Lambda execution
resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.prefix}-lambda-execution-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# IAM assume role policy document for Lambda
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM policy for Lambda basic execution
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_execution_role.name
}

# IAM policy for DynamoDB access
resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name = "${var.prefix}-lambda-dynamodb-policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = data.aws_iam_policy_document.lambda_dynamodb_access.json
}

# IAM policy document for DynamoDB access
data "aws_iam_policy_document" "lambda_dynamodb_access" {
  statement {
    effect = "Allow"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:UpdateItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan",
      "dynamodb:Query"
    ]
    resources = [
      data.terraform_remote_state.data_store.outputs.dynamodb_table_arn,
      "${data.terraform_remote_state.data_store.outputs.dynamodb_table_arn}/*"
    ]
  }
}

# Lambda function for GET /todos
resource "aws_lambda_function" "get_todos" {
  function_name = "${var.prefix}-get-todos"
  role         = aws_iam_role.lambda_execution_role.arn
  handler      = var.lambda_runtime == "python3.9" ? "index.lambda_handler" : "index.handler"
  runtime      = var.lambda_runtime
  timeout      = var.lambda_timeout

  filename         = "lambda_placeholder.zip"
  source_code_hash = data.archive_file.lambda_placeholder.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = data.terraform_remote_state.data_store.outputs.dynamodb_table_name
      LOG_LEVEL          = "INFO"
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_get_todos,
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy.lambda_dynamodb_policy
  ]
}

# Lambda function for POST /todos
resource "aws_lambda_function" "create_todo" {
  function_name = "${var.prefix}-create-todo"
  role         = aws_iam_role.lambda_execution_role.arn
  handler      = var.lambda_runtime == "python3.9" ? "index.lambda_handler" : "index.handler"
  runtime      = var.lambda_runtime
  timeout      = var.lambda_timeout

  filename         = "lambda_placeholder.zip"
  source_code_hash = data.archive_file.lambda_placeholder.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = data.terraform_remote_state.data_store.outputs.dynamodb_table_name
      LOG_LEVEL          = "INFO"
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_create_todo,
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy.lambda_dynamodb_policy
  ]
}

# Lambda function for PUT /todos/{id}
resource "aws_lambda_function" "update_todo" {
  function_name = "${var.prefix}-update-todo"
  role         = aws_iam_role.lambda_execution_role.arn
  handler      = var.lambda_runtime == "python3.9" ? "index.lambda_handler" : "index.handler"
  runtime      = var.lambda_runtime
  timeout      = var.lambda_timeout

  filename         = "lambda_placeholder.zip"
  source_code_hash = data.archive_file.lambda_placeholder.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = data.terraform_remote_state.data_store.outputs.dynamodb_table_name
      LOG_LEVEL          = "INFO"
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_update_todo,
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy.lambda_dynamodb_policy
  ]
}

# Lambda function for DELETE /todos/{id}
resource "aws_lambda_function" "delete_todo" {
  function_name = "${var.prefix}-delete-todo"
  role         = aws_iam_role.lambda_execution_role.arn
  handler      = var.lambda_runtime == "python3.9" ? "index.lambda_handler" : "index.handler"
  runtime      = var.lambda_runtime
  timeout      = var.lambda_timeout

  filename         = "lambda_placeholder.zip"
  source_code_hash = data.archive_file.lambda_placeholder.output_base64sha256

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = data.terraform_remote_state.data_store.outputs.dynamodb_table_name
      LOG_LEVEL          = "INFO"
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda_delete_todo,
    aws_iam_role_policy_attachment.lambda_basic_execution,
    aws_iam_role_policy.lambda_dynamodb_policy
  ]
}

# Placeholder Lambda deployment package
data "archive_file" "lambda_placeholder" {
  type        = "zip"
  output_path = "lambda_placeholder.zip"
  source {
    content = var.lambda_runtime == "python3.9" ? <<EOF
import json

def lambda_handler(event, context):
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
        },
        'body': json.dumps({'message': 'Function not implemented yet'})
    }
EOF
    : <<EOF
exports.handler = async (event) => {
    return {
        statusCode: 200,
        headers: {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'GET,POST,PUT,DELETE,OPTIONS',
            'Access-Control-Allow-Headers': 'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'
        },
        body: JSON.stringify({ message: 'Function not implemented yet' })
    };
};
EOF
    filename = "index.${var.lambda_runtime == "python3.9" ? "py" : "js"}"
  }
}

# API Gateway REST API
resource "aws_api_gateway_rest_api" "todo_api" {
  name        = "${var.prefix}-todo-api"
  description = "Todo API for ${var.environment} environment"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API Gateway Resource: /todos
resource "aws_api_gateway_resource" "todos" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_rest_api.todo_api.root_resource_id
  path_part   = "todos"
}

# API Gateway Resource: /todos/{id}
resource "aws_api_gateway_resource" "todo_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  parent_id   = aws_api_gateway_resource.todos.id
  path_part   = "{id}"
}

# API Gateway Method: GET /todos
resource "aws_api_gateway_method" "get_todos" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todos.id
  http_method   = "GET"
  authorization = "NONE"
}

# API Gateway Method: POST /todos
resource "aws_api_gateway_method" "create_todo" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todos.id
  http_method   = "POST"
  authorization = "NONE"
}

# API Gateway Method: PUT /todos/{id}
resource "aws_api_gateway_method" "update_todo" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "PUT"
  authorization = "NONE"
}

# API Gateway Method: DELETE /todos/{id}
resource "aws_api_gateway_method" "delete_todo" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "DELETE"
  authorization = "NONE"
}

# API Gateway Method: OPTIONS /todos (for CORS)
resource "aws_api_gateway_method" "options_todos" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todos.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# API Gateway Method: OPTIONS /todos/{id} (for CORS)
resource "aws_api_gateway_method" "options_todo_id" {
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  resource_id   = aws_api_gateway_resource.todo_id.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# API Gateway Integration: GET /todos
resource "aws_api_gateway_integration" "get_todos" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.get_todos.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.get_todos.invoke_arn
}

# API Gateway Integration: POST /todos
resource "aws_api_gateway_integration" "create_todo" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.create_todo.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.create_todo.invoke_arn
}

# API Gateway Integration: PUT /todos/{id}
resource "aws_api_gateway_integration" "update_todo" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.update_todo.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.update_todo.invoke_arn
}

# API Gateway Integration: DELETE /todos/{id}
resource "aws_api_gateway_integration" "delete_todo" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.delete_todo.http_method

  integration_http_method = "POST"
  type                   = "AWS_PROXY"
  uri                    = aws_lambda_function.delete_todo.invoke_arn
}

# API Gateway Integration: OPTIONS /todos (CORS)
resource "aws_api_gateway_integration" "options_todos" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.options_todos.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

# API Gateway Integration: OPTIONS /todos/{id} (CORS)
resource "aws_api_gateway_integration" "options_todo_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.options_todo_id.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

# API Gateway Method Response: GET /todos
resource "aws_api_gateway_method_response" "get_todos_200" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.get_todos.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# API Gateway Method Response: POST /todos
resource "aws_api_gateway_method_response" "create_todo_201" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.create_todo.http_method
  status_code = "201"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# API Gateway Method Response: PUT /todos/{id}
resource "aws_api_gateway_method_response" "update_todo_200" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.update_todo.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# API Gateway Method Response: DELETE /todos/{id}
resource "aws_api_gateway_method_response" "delete_todo_204" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.delete_todo.http_method
  status_code = "204"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# API Gateway Method Response: OPTIONS /todos
resource "aws_api_gateway_method_response" "options_todos_200" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.options_todos.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# API Gateway Method Response: OPTIONS /todos/{id}
resource "aws_api_gateway_method_response" "options_todo_id_200" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.options_todo_id.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# API Gateway Integration Response: OPTIONS /todos
resource "aws_api_gateway_integration_response" "options_todos" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todos.id
  http_method = aws_api_gateway_method.options_todos.http_method
  status_code = aws_api_gateway_method_response.options_todos_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'${join(",", var.cors_allowed_origins)}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.cors_allowed_methods)}'"
    "method.response.header.Access-Control-Allow-Headers" = "'${join(",", var.cors_allowed_headers)}'"
  }

  depends_on = [aws_api_gateway_integration.options_todos]
}

# API Gateway Integration Response: OPTIONS /todos/{id}
resource "aws_api_gateway_integration_response" "options_todo_id" {
  rest_api_id = aws_api_gateway_rest_api.todo_api.id
  resource_id = aws_api_gateway_resource.todo_id.id
  http_method = aws_api_gateway_method.options_todo_id.http_method
  status_code = aws_api_gateway_method_response.options_todo_id_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'${join(",", var.cors_allowed_origins)}'"
    "method.response.header.Access-Control-Allow-Methods" = "'${join(",", var.cors_allowed_methods)}'"
    "method.response.header.Access-Control-Allow-Headers" = "'${join(",", var.cors_allowed_headers)}'"
  }

  depends_on = [aws_api_gateway_integration.options_todo_id]
}

# Lambda permissions for API Gateway
resource "aws_lambda_permission" "allow_apigateway_get_todos" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_todos.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_apigateway_create_todo" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_todo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_apigateway_update_todo" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_todo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_apigateway_delete_todo" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_todo.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.todo_api.execution_arn}/*/*"
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "todo_api_deployment" {
  depends_on = [
    aws_api_gateway_integration.get_todos,
    aws_api_gateway_integration.create_todo,
    aws_api_gateway_integration.update_todo,
    aws_api_gateway_integration.delete_todo,
    aws_api_gateway_integration.options_todos,
    aws_api_gateway_integration.options_todo_id,
    aws_api_gateway_integration_response.options_todos,
    aws_api_gateway_integration_response.options_todo_id,
    aws_lambda_permission.allow_apigateway_get_todos,
    aws_lambda_permission.allow_apigateway_create_todo,
    aws_lambda_permission.allow_apigateway_update_todo,
    aws_lambda_permission.allow_apigateway_delete_todo
  ]

  rest_api_id = aws_api_gateway_rest_api.todo_api.id

  lifecycle {
    create_before_destroy = true
  }
}

# API Gateway Stage
resource "aws_api_gateway_stage" "todo_api_stage" {
  deployment_id = aws_api_gateway_deployment.todo_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.todo_api.id
  stage_name    = var.api_gateway_stage_name
}
# KMS Key for DynamoDB encryption
resource "aws_kms_key" "dynamodb" {
  count = var.enable_encryption ? 1 : 0

  description             = "KMS key for DynamoDB table encryption - ${local.prefix}"
  deletion_window_in_days = var.kms_key_deletion_window
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow DynamoDB Service"
        Effect = "Allow"
        Principal = {
          Service = "dynamodb.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "dynamodb.${var.aws_region}.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${local.prefix}-dynamodb-key"
  })
}

resource "aws_kms_alias" "dynamodb" {
  count = var.enable_encryption ? 1 : 0

  name          = local.kms_key_alias
  target_key_id = aws_kms_key.dynamodb[0].key_id
}

# DynamoDB Table for Todo Items
resource "aws_dynamodb_table" "todo_items" {
  name           = local.table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  # Enable encryption at rest
  server_side_encryption {
    enabled     = var.enable_encryption
    kms_key_arn = var.enable_encryption ? aws_kms_key.dynamodb[0].arn : null
  }

  # Enable point-in-time recovery
  point_in_time_recovery {
    enabled = var.enable_point_in_time_recovery
  }

  # Backup configuration
  dynamic "ttl" {
    for_each = var.backup_retention_period > 0 ? [1] : []
    content {
      attribute_name = "ttl"
      enabled        = false # TTL is disabled for todo items - they don't expire
    }
  }

  tags = merge(local.common_tags, {
    Name = local.table_name
    Type = "DynamoDB"
  })

  lifecycle {
    prevent_destroy = true
  }
}

# Data source to get current AWS account information
data "aws_caller_identity" "current" {}

# Data source for DynamoDB service principal
data "aws_iam_policy_document" "dynamodb_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

# IAM Role for DynamoDB access
resource "aws_iam_role" "dynamodb_role" {
  name               = local.dynamodb_role_name
  assume_role_policy = data.aws_iam_policy_document.dynamodb_assume_role.json

  tags = merge(local.common_tags, {
    Name = local.dynamodb_role_name
    Type = "IAM-Role"
  })
}

# IAM Policy Document for DynamoDB operations
data "aws_iam_policy_document" "dynamodb_policy" {
  # DynamoDB table operations
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
      aws_dynamodb_table.todo_items.arn,
      "${aws_dynamodb_table.todo_items.arn}/*"
    ]
  }

  # KMS permissions for DynamoDB encryption
  dynamic "statement" {
    for_each = var.enable_encryption ? [1] : []
    content {
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      resources = [aws_kms_key.dynamodb[0].arn]
      condition {
        test     = "StringEquals"
        variable = "kms:ViaService"
        values   = ["dynamodb.${var.aws_region}.amazonaws.com"]
      }
    }
  }

  # CloudWatch Logs permissions
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:*"]
  }
}

# IAM Policy for DynamoDB operations
resource "aws_iam_role_policy" "dynamodb_policy" {
  name   = local.dynamodb_policy_name
  role   = aws_iam_role.dynamodb_role.id
  policy = data.aws_iam_policy_document.dynamodb_policy.json
}
# Lambdaパラメータシート

## Lambda基本設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| lambda_runtime | python3.9 | ランタイムバージョン（python3.9, nodejs18.x） |
| lambda_timeout | 30 | タイムアウト秒数（1-900） |
| prefix | web3-todo-dev | リソース名プレフィックス（1-20文字） |

## Lambda関数定義
| 関数名 | 用途 | ハンドラー | 環境変数 |
| --- | --- | --- | --- |
| ${prefix}-get-todos | TODO一覧取得 | index.lambda_handler | DYNAMODB_TABLE_NAME, LOG_LEVEL |
| ${prefix}-create-todo | TODO作成 | index.lambda_handler | DYNAMODB_TABLE_NAME, LOG_LEVEL |
| ${prefix}-update-todo | TODO更新 | index.lambda_handler | DYNAMODB_TABLE_NAME, LOG_LEVEL |
| ${prefix}-delete-todo | TODO削除 | index.lambda_handler | DYNAMODB_TABLE_NAME, LOG_LEVEL |

## CloudWatchログ設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| retention_in_days | 14 | ログ保持期間（日） |
| log_group_name | /aws/lambda/${prefix}-{function-name} | ロググループ名 |

## IAMロール・ポリシー
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| execution_role | ${prefix}-lambda-execution-role | Lambda実行ロール |
| basic_execution_policy | AWSLambdaBasicExecutionRole | AWS管理ポリシー |
| dynamodb_policy | ${prefix}-lambda-dynamodb-policy | カスタムDynamoDB権限ポリシー |

## DynamoDB権限
| アクション | 対象リソース | 用途 |
| --- | --- | --- |
| dynamodb:GetItem | data-store state DynamoDB table | アイテム取得 |
| dynamodb:PutItem | data-store state DynamoDB table | アイテム作成 |
| dynamodb:UpdateItem | data-store state DynamoDB table | アイテム更新 |
| dynamodb:DeleteItem | data-store state DynamoDB table | アイテム削除 |
| dynamodb:Scan | data-store state DynamoDB table | 全件検索 |
| dynamodb:Query | data-store state DynamoDB table | 条件検索 |

## Remote Stateの依存関係
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| data_store_state_bucket | web3-todo-app-terraform-state | data-store stateのS3バケット |
| data_store_state_key | dev/data-store/terraform.tfstate | data-store stateのS3キー |
| dependency | DynamoDB table ARN/name | data-storeからの参照 |

## Lambda権限設定
| 対象サービス | 権限 | 用途 |
| --- | --- | --- |
| API Gateway | lambda:InvokeFunction | API GatewayからのLambda関数実行 |
| CloudWatch Logs | logs:CreateLogGroup, logs:CreateLogStream, logs:PutLogEvents | ログ出力権限 |

## バリデーション項目
| パラメータ | 制約 | エラーメッセージ |
| --- | --- | --- |
| prefix | 1-20文字 | "Prefix must be between 1 and 20 characters." |
| lambda_runtime | python3.9 or nodejs18.x | "Lambda runtime must be either python3.9 or nodejs18.x." |
| lambda_timeout | 1-900秒 | "Lambda timeout must be between 1 and 900 seconds." |
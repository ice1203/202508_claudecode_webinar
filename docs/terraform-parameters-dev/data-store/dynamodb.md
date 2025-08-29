# DynamoDB パラメータシート

**作成日**: 2025-01-28  
**環境**: dev  
**コンポーネント**: data-store  
**対象パス**: terraform/environments/dev/data-store

## DynamoDB基本設定

| 項目 | 設定値 | データ型 | 備考 |
| --- | --- | --- | --- |
| table_name | web3-todo-app-dev-todo-items | string | プロジェクト名-環境名-todo-items |
| billing_mode | PROVISIONED | string | プロビジョニングモード（固定値） |
| read_capacity | 5 | number | 読み取り容量（1-100） |
| write_capacity | 5 | number | 書き込み容量（1-100） |
| hash_key | id | string | パーティションキー（固定値） |
| backup_retention_period | 7 | number | バックアップ保持期間（1-35日） |
| enable_point_in_time_recovery | true | bool | ポイントインタイムリカバリ有効化 |
| prevent_destroy | true | bool | 削除保護（固定値） |

### DynamoDB属性定義

| 属性名 | データ型 | 用途 |
| --- | --- | --- |
| id | S (String) | パーティションキー - TodoアイテムのID |

## 暗号化設定（KMS）

| 項目 | 設定値 | データ型 | 備考 |
| --- | --- | --- | --- |
| enable_encryption | true | bool | DynamoDB暗号化有効化 |
| kms_key_deletion_window | 7 | number | KMS キー削除猶予期間（7-30日） |
| enable_key_rotation | true | bool | 自動キーローテーション（固定値） |
| kms_key_alias | alias/web3-todo-app-dev-dynamodb-key | string | KMSキーエイリアス |

### KMSキーポリシー

| 権限対象 | 許可されるアクション | 条件 |
| --- | --- | --- |
| AWS アカウントルート | kms:* | - |
| DynamoDB サービス | Encrypt, Decrypt, ReEncrypt*, GenerateDataKey*, CreateGrant, DescribeKey | kms:ViaService = dynamodb.ap-northeast-1.amazonaws.com |

## IAMロール・ポリシー

### IAMロール基本設定

| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| role_name | web3-todo-app-dev-dynamodb-role | DynamoDB アクセス用ロール |
| policy_name | web3-todo-app-dev-dynamodb-policy | DynamoDB アクセスポリシー |
| assume_role_principal | lambda.amazonaws.com | Lambda がアスーム可能 |

### DynamoDB 操作権限

| アクション | 対象リソース | 備考 |
| --- | --- | --- |
| dynamodb:GetItem | table ARN + table ARN/* | アイテム取得 |
| dynamodb:PutItem | table ARN + table ARN/* | アイテム作成 |
| dynamodb:UpdateItem | table ARN + table ARN/* | アイテム更新 |
| dynamodb:DeleteItem | table ARN + table ARN/* | アイテム削除 |
| dynamodb:Scan | table ARN + table ARN/* | テーブルスキャン |
| dynamodb:Query | table ARN + table ARN/* | クエリ実行 |

### KMS 暗号化権限（暗号化有効時のみ）

| アクション | 対象リソース | 条件 |
| --- | --- | --- |
| kms:Encrypt | KMS キー ARN | kms:ViaService = dynamodb.ap-northeast-1.amazonaws.com |
| kms:Decrypt | KMS キー ARN | kms:ViaService = dynamodb.ap-northeast-1.amazonaws.com |
| kms:ReEncrypt* | KMS キー ARN | kms:ViaService = dynamodb.ap-northeast-1.amazonaws.com |
| kms:GenerateDataKey* | KMS キー ARN | kms:ViaService = dynamodb.ap-northeast-1.amazonaws.com |
| kms:DescribeKey | KMS キー ARN | kms:ViaService = dynamodb.ap-northeast-1.amazonaws.com |

### CloudWatch Logs 権限

| アクション | 対象リソース |
| --- | --- |
| logs:CreateLogGroup | arn:aws:logs:ap-northeast-1:${account_id}:* |
| logs:CreateLogStream | arn:aws:logs:ap-northeast-1:${account_id}:* |
| logs:PutLogEvents | arn:aws:logs:ap-northeast-1:${account_id}:* |

## プロジェクト共通設定

| 項目 | 設定値 | データ型 | 備考 |
| --- | --- | --- | --- |
| project_name | web3-todo-app | string | プロジェクト名（1-50文字） |
| environment | dev | string | 環境名（dev/staging/prod） |
| aws_region | ap-northeast-1 | string | デプロイ対象リージョン |

### 共通タグ

| タグキー | タグ値 | 自動設定 |
| --- | --- | --- |
| Environment | dev | Yes |
| Project | web3-todo-app | Yes |
| Component | data-store | Yes |
| ManagedBy | terraform | Yes |
| CreatedDate | YYYY-MM-DD（実行時） | Yes |

## 出力値（Outputs）

| 出力名 | 説明 | 用途 |
| --- | --- | --- |
| dynamodb_table_name | DynamoDB テーブル名 | Lambda 関数での参照用 |
| dynamodb_table_arn | DynamoDB テーブル ARN | IAM ポリシーでの参照用 |
| dynamodb_table_id | DynamoDB テーブル ID | リソース識別用 |
| dynamodb_table_stream_arn | DynamoDB ストリーム ARN | ストリーム処理用（現在は無効） |
| iam_role_arn | IAM ロール ARN | Lambda 関数への付与用 |
| iam_role_name | IAM ロール名 | 他のリソースでの参照用 |
| kms_key_arn | KMS キー ARN | 暗号化時の参照用 |
| kms_key_id | KMS キー ID | AWS リソースでの参照用 |
| kms_key_alias | KMS キー エイリアス | 人間が読める形での参照 |

## バリデーションルール

### Variables バリデーション

| 変数名 | バリデーション条件 | エラーメッセージ |
| --- | --- | --- |
| aws_region | 正規表現: ^[a-z0-9-]+$ | AWS region must contain only lowercase letters, numbers, and hyphens. |
| environment | 許可値: dev, staging, prod | Environment must be one of: dev, staging, prod. |
| project_name | 長さ: 1-50文字 | Project name must be between 1 and 50 characters. |
| read_capacity | 範囲: 1-100 | Read capacity must be between 1 and 100. |
| write_capacity | 範囲: 1-100 | Write capacity must be between 1 and 100. |
| kms_key_deletion_window | 範囲: 7-30日 | KMS key deletion window must be between 7 and 30 days. |
| backup_retention_period | 範囲: 1-35日 | Backup retention period must be between 1 and 35 days. |

## Terraform 設定情報

| 項目 | 設定値 |
| --- | --- |
| terraform_version | >= 1.7 |
| aws_provider_version | 5.34.0 |
| aws_provider_source | hashicorp/aws |

## セキュリティ考慮事項

- ✅ KMS による暗号化が有効化されている
- ✅ IAM ロールによる最小権限の原則
- ✅ ViaService 条件によるKMS アクセス制限
- ✅ ポイントインタイムリカバリが有効
- ✅ Lifecycle の prevent_destroy でデータ保護
- ⚠️ DynamoDB ストリームは現在無効（TTL設定のみ存在、機能は無効）

## 運用ガイドライン

### 容量調整

- 読み取り・書き込み容量は 1-100 の範囲で調整可能
- プロダクション環境ではオンデマンドも検討

### バックアップ戦略

- ポイントインタイムリカバリで35日間の復旧が可能
- 定期バックアップの保持期間は 1-35日で調整可能

### 暗号化管理

- KMS キーの自動ローテーションが有効
- キー削除は最短7日、最長30日の猶予期間設定

### モニタリング

- CloudWatch Logs への書き込み権限を付与済み
- DynamoDB メトリクスは CloudWatch で自動収集
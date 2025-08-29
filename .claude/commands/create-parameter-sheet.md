# /create-parameter-sheet

**Command Type**: Terraform Parameter Documentation Generator  
**Domain**: Infrastructure as Code Projects  
**Purpose**: Terraformコードからパラメータ一覧表を新規作成

## Overview

Terraformプロジェクトの全`.tf`ファイルを解析し、体系的なパラメータシートを新規生成します。

**特徴**: 初回作成時用。variables、locals、data定義を包括的に解析し、実装に使える詳細ドキュメントを生成

## Usage

```bash
/create-parameter-sheet <terraform_path> [output_format]
```

### Parameters

| Parameter | Type | Description | Required | Example |
|-----------|------|-------------|----------|---------|
| `terraform_path` | Directory Path | Terraformコードのルートディレクトリ | Yes | `terraform/environments/dev/` |
| `output_format` | String | 出力形式（markdown/csv/table） | No | `markdown` |

## Processing Flow

1. **State識別**: Terraformディレクトリ構造からstate境界を判定
2. **サービス分類**: リソース種別によるサービス分類（data-store/monitoring/services）
3. **セキュリティ統合**: SG/IAM/KMSを対象サービスのパラメータシートに統合
4. **ファイル生成**: サービス別・state別のパラメータシート出力

## Service-specific Templates

### DynamoDB (data-store/dynamodb.md)
```markdown
# DynamDBパラメータシート

## DynamoDB基本設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| read_capacity | 5 | 読み取り容量（1-100） |
| write_capacity | 5 | 書き込み容量（1-100） |
| enable_encryption | true | 暗号化有効化 |

## セキュリティグループ
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| sg_name | dynamodb-sg | DynamoDB用セキュリティグループ |
| ingress_ports | [] | DynamoDBは通常ポート開放不要 |

## IAMポリシー
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| dynamodb_read_policy | AmazonDynamoDBReadOnlyAccess | 読み取り専用ポリシー |
| dynamodb_write_policy | カスタム | 書き込み権限付与 |

## KMS暗号化
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| kms_key_deletion_window | 7 | 削除までの日数（7-30） |
| enable_key_rotation | true | 自動キーローテーション |
```

### Lambda (services/lambda.md)
```markdown
# Lambdaパラメータシート

## Lambda基本設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| lambda_runtime | python3.9 | ランタイムバージョン |
| lambda_timeout | 30 | タイムアウト秒数（1-900） |
| memory_size | 128 | メモリサイズ（MB） |

## セキュリティグループ
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| lambda_sg_name | lambda-sg | Lambda用セキュリティグループ |
| vpc_config | enabled | VPC内実行の場合 |

## IAMロール・ポリシー
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| execution_role | lambda-execution-role | Lambda実行ロール |
| vpc_execution_policy | AWSLambdaVPCAccessExecutionRole | VPC実行時必須 |
| custom_policy | カスタム | 業務固有権限 |
```

## Analysis Features

- **バリデーション**: 範囲制限、形式チェック、許可値リスト
- **セキュリティ**: sensitive変数識別、ハードコード検出
- **ベストプラクティス**: 命名規則、説明文充実度評価
- **依存関係**: variables→locals→data→resource間の参照関係追跡

## Output Structure

### ディレクトリ構造
```
docs/
├── terraform-parameters-[env]/
│   ├── data-store/
│   │   └── dynamodb.md                  # DynamoDB + 関連SG/IAM/KMS
│   ├── monitoring/
│   │   └── cloudwatch.md                # CloudWatch + 関連IAM/KMS
│   └── services/
│       ├── lambda.md                    # Lambda + 関連SG/IAM
│       └── apigateway.md                # API Gateway + 関連IAM
```

### 出力形式
- **Markdown**: サービス別ファイル
- **CSV**: 統合形式（必要に応じて）
- **Table**: コンソール表示

## Resource Classification

### サービス分類ルール
- **data-store**: DynamoDB, RDS, ElastiCache関連リソース
- **monitoring**: CloudWatch, X-Ray関連リソース  
- **services**: Lambda, API Gateway, ECS関連リソース

### セキュリティリソース統合ルール
- **SecurityGroup**: 対象サービスのパラメータシートに統合
- **IAM Role/Policy**: 対象サービスのパラメータシートに統合
- **KMS Key**: 暗号化対象サービスのパラメータシートに統合

## Usage Examples

```bash
# dev環境全体のパラメータシート生成
/create-parameter-sheet terraform/environments/dev/

# 特定のstateのみ（data-store）
/create-parameter-sheet terraform/environments/dev/data-store/

# 本番環境
/create-parameter-sheet terraform/environments/prod/
```

### 生成例
```
docs/terraform-parameters-dev/
├── data-store/
│   └── dynamodb.md              # DynamoDB + 関連SG/IAM/KMS
├── monitoring/  
│   └── cloudwatch.md            # CloudWatch + 関連IAM/KMS
└── services/
    ├── lambda.md                # Lambda + 関連SG/IAM
    └── apigateway.md            # API Gateway + 関連IAM
```

## 技術検証要求
AWS Knowledge MCPサーバーおよびTerraform MCPサーバーを使用して、以下の正確性を確認すること：
- AWSサービスのパラメータ制約値と推奨設定
- Terraformリソース定義の構文と属性
- セキュリティベストプラクティスの適用

**Note**: 任意のTerraformプロジェクト構造に対応した包括的パラメータドキュメント新規生成
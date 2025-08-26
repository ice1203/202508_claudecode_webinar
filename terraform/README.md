# Web3層構造Todoアプリケーション - Terraform実装

AWS上でのサーバーレス構成によるWeb3層構造Todoアプリケーションのインフラ構築用Terraformコード。

## 📋 システム概要

**アーキテクチャ**: 3-tier Web Application (サーバーレス構成)
- **プレゼンテーション層**: React/Vue.js (フロントエンド、別途実装)
- **アプリケーション層**: API Gateway + AWS Lambda
- **データ層**: Amazon DynamoDB

## 🏗️ インフラ構成

### State分離構成
```
terraform/environments/dev/
├── data-store/     # DynamoDB + IAM (データ永続化層)
├── services/       # API Gateway + Lambda + IAM (アプリケーション層)  
└── monitoring/     # CloudWatch Logs (監視・ログ層)
```

### 主要AWSリソース
- **DynamoDB**: todo-items テーブル (KMS暗号化)
- **API Gateway**: REST API (4エンドポイント)
- **Lambda**: CRUD操作用関数 (4個)
- **CloudWatch**: ログ出力・監視
- **IAM**: 最小権限ロール・ポリシー

## 🔧 デプロイ手順

### 前提条件
- AWS CLI設定済み
- Terraform 1.7+
- 適切なIAM権限

### 1. Backend設定 (初回のみ)
```bash
# S3バケットとDynamoDBテーブル作成
aws s3 mb s3://web3-todo-terraform-state --region ap-northeast-1
aws dynamodb create-table --table-name terraform-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST --region ap-northeast-1
```

### 2. State別デプロイ
```bash
# 1. データストア (DynamoDB)
cd terraform/environments/dev/data-store
terraform init
terraform plan
terraform apply

# 2. サービス (API Gateway + Lambda)  
cd ../services
terraform init
terraform plan
terraform apply

# 3. 監視 (CloudWatch)
cd ../monitoring
terraform init  
terraform plan
terraform apply
```

## 🎯 API エンドポイント

デプロイ後に以下のエンドポイントが利用可能:

```
GET    /todos         # Todoリスト取得
POST   /todos         # 新規Todo作成
PUT    /todos/{id}    # Todo更新
DELETE /todos/{id}    # Todo削除
```

## 📊 品質スコア

| Component | 品質スコア | 状態 | 主な特徴 |
|-----------|------------|------|----------|
| data-store | 92.3/100 | ✅ 優秀 | KMS暗号化、IAM最小権限 |
| services | 85/100 | ✅ 良好 | CORS設定、HTTPS対応 |
| monitoring | 87.5/100 | ✅ 良好 | ログ暗号化、適切な保持期間 |

## ⚠️ 重要な注意事項

### 1. Backend設定統一が必要
現在、State間でS3バケット名に不整合があります:
```bash
# 修正前
data-store:  backend設定なし
services:    web3-todo-app-terraform-state  
monitoring:  web3-todo-terraform-state

# 修正後 (推奨)
全state: web3-todo-terraform-state
```

### 2. 本番環境移行時の注意
- CORS設定を特定ドメインに制限
- API認証方式の追加検討
- Lambda関数のタイムアウト・メモリ調整

## 🔐 セキュリティ設定

### 準拠要件
- **NFR-101**: HTTPS通信 ✅
- **NFR-102**: CORS設定 ✅  
- **NFR-103**: IAM最小権限原則 ✅

### 暗号化
- DynamoDB: KMS暗号化 (専用キー)
- CloudWatch Logs: KMS暗号化対応
- S3 Backend: 暗号化有効

## 📝 運用・管理

### 監視
- CloudWatch Logs: API Gateway + Lambda
- 保持期間: 7日 (dev環境)

### 状態管理
- Remote State: S3 + DynamoDB Lock
- 暗号化転送・保存対応

### タグ付け戦略
```hcl
Environment = "dev"
Project     = "web3-todo-app"  
Component   = "data-store|services|monitoring"
ManagedBy   = "terraform"
```

## 🚀 次のステップ

1. **Backend設定統一** (terraform-enterprise-implementer実行)
2. **Lambda関数コード実装**
3. **フロントエンド連携**
4. **本番環境設定**

## 📞 サポート

- **要件定義**: `docs/spec/web3-todo-app-requirements.md`
- **実装ログ**: `terraform/.proto-tasks/implementation-log.md` 
- **品質チェック**: `terraform/.proto-tasks/component-status.json`
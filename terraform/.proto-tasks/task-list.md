# Terraform プロトタイプ実装タスクリスト

## 要件概要
Web3層構造Todoアプリケーション - DynamoDB、API Gateway、Lambda、Terraformを使用したサーバーレス構成
- 対象環境: dev
- 要件定義: docs/spec/web3-todo-app-requirements.md

## State分離構成

### data-store (データ永続化層)
**DynamoDBテーブル構成:**
- Table: todo-items
- Primary Key: id (String, UUID)
- Attributes: title, description, completed, createdAt, updatedAt
- Capacity: Read 5 / Write 5

**IAMロール:**
- DynamoDB操作権限 (GetItem, PutItem, UpdateItem, DeleteItem, Scan)

### services (アプリケーション層)
**API Gateway:**
- REST API設定
- CORS設定
- HTTPSエンドポイント

**Lambda Functions:**
- GET /todos (リスト取得)
- POST /todos (新規作成)
- PUT /todos/{id} (更新)
- DELETE /todos/{id} (削除)

**IAMロール:**
- Lambda実行ロール
- DynamoDBアクセス権限
- CloudWatchログ出力権限

### monitoring (監視・ログ層)
**CloudWatch Log Groups:**
- API Gatewayアクセスログ
- Lambda関数実行ログ

## Phase 実装計画

### Phase 1: データストア基盤
- [ ] data-store/ 実装

### Phase 2: サービス実行環境
- [ ] services/ 実装

### Phase 3: 監視通知
- [ ] monitoring/ 実装

## 品質チェックタスク
- [ ] data-store/ 品質チェック
- [ ] services/ 品質チェック
- [ ] monitoring/ 品質チェック

## 実装ステータス
開始時刻: 2025-01-26 14:XX:XX JST
環境: dev
状態: 実装準備中
# CLAUDE.md

このファイルは、このリポジトリでコードを作業する際のClaude Codeのガイダンスを提供します。

## プロジェクト概要

AWS上でのWeb3層構造Todoアプリケーション - DynamoDB、API Gateway、Lambda、Terraformを使用したサーバーレス構成

## Terraform構成

### 構造
- `terraform/environments/dev/` - 開発環境用構成
  - `iam/` - IAMロール・ポリシー
  - `data-store/` - DynamoDB・CloudWatchログ
  - `services/` - Lambda・API Gateway

### デプロイメント順序
1. IAM
2. データストア
3. サービス

# /update-parameter-sheet

**Command Type**: Terraform Parameter Documentation Updater  
**Domain**: Infrastructure as Code Projects  
**Purpose**: Terraformコード変更に基づいてパラメータシートを差分更新

## Overview

Terraformコードのgit差分からパラメータ変更を検出し、既存パラメータシートを更新します。

**特徴**: git diffベースで正確な変更検出。ユーザーカスタマイズ（備考欄等）を保持しつつ、Terraformの変更のみを反映

## Usage

```bash
/update-parameter-sheet <terraform_path> <existing_sheet_path>
```

### Parameters

| Parameter | Type | Description | Required | Example |
|-----------|------|-------------|----------|---------|
| `terraform_path` | Directory Path | Terraformコードのルートディレクトリ | Yes | `terraform/environments/dev/` |
| `existing_sheet_path` | File Path | 既存のパラメータシートファイル | Yes | `docs/terraform-parameters-dev.md` |

## Processing Flow

1. **Git Diff解析**: Terraformファイルのgit差分を取得・解析
2. **変更抽出**: 追加・削除・変更されたvariable/locals/data定義を特定
3. **既存シート解析**: 現在のパラメータシートからユーザーカスタマイズを抽出
4. **保護更新**: 備考欄等のユーザーカスタマイズを保持してTerraform変更のみ反映

## Update Types

### 自動更新項目
- **新規パラメータ**: デフォルト値、制約条件付きで自動追加
- **削除パラメータ**: 削除マークまたは取り消し線で表示
- **変更パラメータ**: デフォルト値、制約条件の自動更新

### 保護項目（更新されない）
- **備考欄**: ユーザーが記載した説明文
- **カスタマイズ値**: 手動で変更した設定値  
- **セクション構造**: ユーザーが調整したレイアウト

## Git Diff Based Change Detection

### 検出対象のTerraform変更
```terraform
# variables.tfでの変更例

# デフォルト値変更
-  default     = 5
+  default     = 10

# 新しいvariable追加
+variable "new_parameter" {
+  type        = string
+  description = "新しく追加されたパラメータ"
+  default     = "default_value"
+}

# validation条件変更
-    condition     = var.read_capacity >= 1 && var.read_capacity <= 100
+    condition     = var.read_capacity >= 1 && var.read_capacity <= 200
```

### パラメータシートでの差分表示
```markdown
## 更新されたパラメータ

| 項目 | 旧値 | 新値 | 備考 |
| --- | --- | --- | --- |
| read_capacity | ~~5~~ | **10** | デフォルト値変更（ユーザーの備考は保持） |
| ~~deleted_param~~ | ~~old_value~~ | - | パラメータ削除 |
| **new_parameter** | - | **"default_value"** | パラメータ追加 |
```

## Usage Examples

```bash
# dev環境全体の更新
/update-parameter-sheet terraform/environments/dev/ docs/terraform-parameters-dev/

# 特定サービスのみ更新
/update-parameter-sheet terraform/environments/dev/data-store/ docs/terraform-parameters-dev/data-store/dynamodb.md

# 本番環境更新
/update-parameter-sheet terraform/environments/prod/ docs/terraform-parameters-prod/
```

## File Structure Support

### 更新対象ファイル自動判定
- **Directory指定**: 配下の全パラメータシートファイルを更新
- **File指定**: 指定ファイルのみ更新
- **セキュリティ統合**: 関連するSG/IAM/KMSも同時更新

## Workflow Integration

### 推奨ワークフロー
1. Terraformコードを編集
2. 変更をgit add（コミット前）
3. `/update-parameter-sheet` 実行
4. パラメータシートの変更内容レビュー
5. 必要に応じて備考欄を手動更新
6. git commit

### Git操作との連携
```bash
# Terraformコード変更後
git add terraform/environments/dev/
/update-parameter-sheet terraform/environments/dev/ docs/terraform-parameters-dev/
# パラメータシートの変更を確認
git add docs/terraform-parameters-dev/
git commit -m "Add new DynamoDB parameter with updated capacity"
```

## Advantages of Git Diff Approach

### 従来方式との比較
| 方式 | 精度 | 効率 | ユーザビリティ |
| --- | --- | --- | --- |
| **全ファイル解析** | 低 | 低 | △ 不要な変更も検出 |
| **Git Diff方式** | 高 | 高 | ○ 実際の変更のみ検出 |

### メリット
- **高精度**: 実際に変更された内容のみを正確に検出
- **高速処理**: 変更ファイルのみを解析
- **意図反映**: 開発者の変更意図に沿った更新
- **履歴管理**: git履歴と連動した変更管理

## 技術検証要求
AWS Knowledge MCPサーバーおよびTerraform MCPサーバーを使用して、以下の正確性を確認すること：
- Terraformコード変更の構文と属性の妥当性
- AWSサービスの最新仕様との整合性
- パラメータ変更によるセキュリティ影響の評価

**Note**: git diffベースで正確な変更検出を行い、ユーザーカスタマイズを保持した効率的な差分更新
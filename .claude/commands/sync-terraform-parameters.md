# /sync-terraform-parameters

**Command Type**: Terraform Parameter Synchronizer  
**Domain**: Infrastructure as Code Projects  
**Purpose**: パラメータシートの変更をTerraformコードに逆反映

## Overview

パラメータシートの変更内容をgit diffから検出し、対応するTerraformコードを自動更新します。

**特徴**: git diffベースの変更検出により、手動で変更したパラメータをTerraformコードに確実に反映

## Usage

```bash
/sync-terraform-parameters <terraform_path> <parameter_sheets_path>
```

### Parameters

| Parameter | Type | Description | Required | Example |
|-----------|------|-------------|----------|---------|
| `terraform_path` | Directory Path | Terraformコードのルートディレクトリ | Yes | `terraform/environments/dev/` |
| `parameter_sheets_path` | Directory Path | パラメータシートのディレクトリ | Yes | `docs/terraform-parameters-dev/` |

## Processing Flow

1. **Git Diff解析**: パラメータシートファイルのgit差分を取得・解析
2. **変更抽出**: 変更されたパラメータの特定（設定値、制約条件等）
3. **対応付け**: パラメータシート変更とTerraformファイルの対応関係を特定
4. **コード反映**: 対応するvariables.tf、locals.tf等を自動更新

## Change Detection from Git Diff

### 検出対象の変更
```markdown
## Git Diffから検出する変更パターン

### デフォルト値変更
-| read_capacity | 5 | DynamoDB読み取り容量（1-100） |
+| read_capacity | 10 | DynamoDB読み取り容量（1-100） |

### 制約条件変更  
-| aws_region | regex | ^[a-z0-9-]+$ | 小文字、数字、ハイフンのみ |
+| aws_region | regex | ^[a-z]{2}-[a-z]+-[0-9]+$ | AWS標準リージョン形式 |

### 新規パラメータ追加
+| new_parameter | "default_value" | 新しく追加されたパラメータ |

### パラメータ削除
-| deleted_parameter | "old_value" | 削除されたパラメータ |
```

## Terraform Code Synchronization

### 反映対象ファイル
- **variables.tf**: variable定義のデフォルト値、validation条件
- **locals.tf**: ローカル値の計算式  
- **terraform.tfvars**: 環境固有値（オプション）

### 反映内容
| 変更種類 | 反映先 | 反映内容 |
| --- | --- | --- |
| デフォルト値変更 | variables.tf | `default = "new_value"` |
| 制約条件変更 | variables.tf | `validation { condition = ... }` |
| 新規パラメータ | variables.tf | 新しいvariable block追加 |
| パラメータ削除 | variables.tf | variable block削除（確認後） |

## Safety Features

### 安全な更新機能
- **バックアップ作成**: 更新前に.tfファイルのバックアップを自動作成
- **変更確認**: 大きな変更は実行前にユーザー確認
- **段階的反映**: ファイル単位での段階的更新

### 確認が必要な変更
```bash
⚠️  以下の変更には確認が必要です:
- パラメータ削除: deleted_parameter
- 制約条件の緩和: validation条件の削除
- 大量のデフォルト値変更: 10個以上の変更

続行しますか? (y/N): 
```

## Usage Examples

```bash
# dev環境のパラメータシート変更を反映
/sync-terraform-parameters terraform/environments/dev/ docs/terraform-parameters-dev/

# 特定サービスのみ反映
/sync-terraform-parameters terraform/environments/dev/data-store/ docs/terraform-parameters-dev/data-store/dynamodb.md

# 本番環境（より慎重な確認）
/sync-terraform-parameters terraform/environments/prod/ docs/terraform-parameters-prod/
```

## Workflow Integration

### 推奨ワークフロー
1. パラメータシートを手動編集
2. 変更内容をgit add（コミット前）
3. `/sync-terraform-parameters` 実行
4. Terraformコードの変更を確認
5. `terraform plan`で影響を確認
6. 問題なければgit commit

### Git操作との連携
```bash
# パラメータシート変更後
git add docs/terraform-parameters-dev/
/sync-terraform-parameters terraform/environments/dev/ docs/terraform-parameters-dev/
terraform plan  # 影響確認
git add terraform/environments/dev/
git commit -m "Update parameters: increase DynamoDB capacity"
```

## Error Handling

### エラーパターンと対処
- **Git差分なし**: パラメータシートに変更がない場合
- **対応ファイル不明**: パラメータに対応するTerraformファイルが見つからない
- **構文エラー**: 生成されたTerraformコードに構文エラーがある場合
- **競合検出**: 同じパラメータが複数ファイルで定義されている場合

## 技術検証要求
AWS Knowledge MCPサーバーおよびTerraform MCPサーバーを使用して、以下の正確性を確認すること：
- パラメータ変更によるTerraformコードの構文検証
- AWSリソースの制約値とvalidation条件の整合性
- Terraform変更によるAWSサービスへの影響評価

**Note**: パラメータシート→Terraformコードの逆方向同期により、ドキュメント駆動開発を実現
# /make-prototype - Terraform プロトタイプ生成・品質チェックコマンド

要件定義フォルダを解析し、サブエージェントによる並列Terraformプロトタイプ実装と品質チェックを実行します。

## 実行フロー

### Phase 1: 要件分析・設計
```bash
/make-prototype [要件定義フォルダパス]
```
- 要件定義ファイル群を分析
- AWSリソース構成を抽出・マッピング
- コンポーネント依存関係を解析
- 実装戦略を策定

### Phase 2: 並列実装・品質チェック
各コンポーネントでサブエージェントが並列実行：
- **terraform-implementer**: Terraformコード実装
- **terraform-code-checker**: 品質チェック・検証

## 使用方法

### 基本実行
```bash
/make-prototype [要件定義フォルダパス]
```

### Options

| Option | Description | Usage | Use Case |
|--------|-------------|-------|----------|
| `--component` | 対象コンポーネント指定 | `/make-prototype [パス] --component=ecs,iam` | 特定リソースのみ実装 |
| `--environment` | 対象環境指定 | `/make-prototype [パス] --environment=dev,staging` | 特定環境のみ構築 |
| `--output-dir` | 出力先変更 | `/make-prototype [パス] --output-dir=custom/` | カスタム出力ディレクトリ |
| `--quality-only` | 品質チェックのみ | `/make-prototype [パス] --quality-only` | 既存コードの品質確認 |
| `--tasks-only` | タスクリストのみ作成 | `/make-prototype [パス] --tasks-only` | 実装計画の事前確認・レビュー |
| `-q` | Quick mode (基本構成のみ) | `/make-prototype [パス] -q` | 最小構成でのプロトタイプ |

## 実行戦略

要件定義から抽出されたAWSリソースを依存関係に基づいて段階的に並列実行：

### 実行フロー
1. **要件解析** - 要件定義ファイルからAWSリソース構成を抽出
2. **依存関係分析** - リソース間の依存関係を自動解析
3. **リソース分類** - 4つの基本State構成に沿ったリソース分類
4. **State分離設計** - 実用的な4State構成に集約
   - **network/**: VPC, Subnet, Internet Gateway, Route Table (共通ネットワーク基盤のみ)
   - **data-store/**: RDS、S3などデータの永続保管用リソースとそれらリソースで使用するIAMロール、セキュリティグループ
   - **services/**: 実際にサービスを行う中核となるリソース群を定義、例えばECS,EKS,EC2,Lambdaとそれらに使用されるIAMロール、セキュリティグループ
   - **monitoring/**: CloudWatch, 監視関連IAMロール
5. **タスク作成** - 4つのstate単位でTerraform実装タスクを生成
6. **並列実行** - 依存関係に基づく段階的な並列実装
7. **品質チェック** - 各state完了時に自動品質検証

## サブエージェント実行

各コンポーネントに対して以下のタスクを並列実行：

1. **Terraform実装タスク** - コンポーネント別Terraformコード生成
2. **品質チェックタスク** - 実装完了後の品質検証とセキュリティ要件準拠確認

## 出力成果物

### 中間管理ファイル
```
terraform/
├── .proto-tasks/
│   ├── task-list.md             # 📋 全体タスクリスト管理
│   ├── component-status.json    # 📊 コンポーネント別進捗状況
│   └── implementation-log.md    # 📝 実装ログ・エラー記録
```

### タスクリスト管理例 (task-list.md)
```markdown
# Terraform プロトタイプ実装タスクリスト

## Phase 1: ネットワーク基盤
- [ ] network/実装

## Phase 2: データストア  
- [ ] data-store/実装

## Phase 3: サービス実行環境
- [ ] services/実装

## Phase 4: 監視通知
- [ ] monitoring/実装

## 品質チェックタスク
- [ ] network/ 品質チェック
- [ ] data-store/ 品質チェック  
- [ ] services/ 品質チェック
- [ ] monitoring/ 品質チェック
```

### 最終出力構造
```
terraform/
├── .proto-tasks/               # 🔧 中間管理ファイル
├── environments/
│   ├── prod/                   # 本番環境
│   │   ├── network/
│   │   ├── data-store/
│   │   ├── services/
│   │   └── monitoring/
│   └── staging/               # テスト環境 (prodと同構造)
├── modules/                   # 再利用可能モジュール
│   ├── terraform-aws-***/     # モジュールA
│   └── terraform-aws-***/     # モジュールB
├── .gitignore                  # Git除外設定
└── README.md                  # セットアップガイド
```

### 進捗管理
- リアルタイム実装状況表示
- 品質チェック結果即時フィードバック
- 推定完了時間・ボトルネック分析
- 完了コンポーネント/未完了コンポーネント分離表示

# CloudWatchパラメータシート

## CloudWatchロググループ設定
| 関数名 | ロググループ名 | 保持期間 | 用途 |
| --- | --- | --- | --- |
| get-todos | /aws/lambda/${prefix}-get-todos | 14日 | TODO一覧取得ログ |
| create-todo | /aws/lambda/${prefix}-create-todo | 14日 | TODO作成ログ |
| update-todo | /aws/lambda/${prefix}-update-todo | 14日 | TODO更新ログ |
| delete-todo | /aws/lambda/${prefix}-delete-todo | 14日 | TODO削除ログ |

## ログ設定詳細
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| retention_in_days | 14 | ログ保持期間（日数） |
| 自動作成 | あり | Lambda関数作成時に自動作成 |
| 暗号化 | デフォルト | CloudWatch標準暗号化 |

## ログアクセス権限
| サービス | 権限 | 用途 |
| --- | --- | --- |
| Lambda実行ロール | logs:CreateLogGroup | ロググループ作成 |
| Lambda実行ロール | logs:CreateLogStream | ログストリーム作成 |
| Lambda実行ロール | logs:PutLogEvents | ログ書き込み |
| 管理ポリシー | AWSLambdaBasicExecutionRole | Lambda標準ログ権限 |

## ログ出力項目
| Lambda関数 | 環境変数 | ログレベル | 出力内容 |
| --- | --- | --- | --- |
| 全Lambda関数 | LOG_LEVEL | INFO | 関数実行ログ |
| 全Lambda関数 | DYNAMODB_TABLE_NAME | - | DynamoDB接続情報 |

## 監視・アラート設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| メトリクス | Lambda標準メトリクス | Duration, Errors, Invocations等 |
| カスタムメトリクス | 未設定 | 必要に応じて追加 |
| アラーム | 未設定 | 本番環境では推奨 |

## ログ分析
| 分析対象 | 用途 | 実装方法 |
| --- | --- | --- |
| エラーログ | 障害分析 | CloudWatch Logs Insights |
| パフォーマンス | 実行時間分析 | Lambda標準メトリクス |
| 利用状況 | 呼び出し頻度 | Invocationsメトリクス |

## コスト最適化
| 項目 | 設定値 | コスト影響 |
| --- | --- | --- |
| ログ保持期間 | 14日 | 短期設定でコスト削減 |
| ログレベル | INFO | 必要最小限の出力 |
| 自動削除 | あり | 保持期間後自動削除 |
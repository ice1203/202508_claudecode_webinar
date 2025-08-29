# API Gatewayパラメータシート

## API Gateway基本設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| api_gateway_stage_name | v1 | ステージ名（必須入力） |
| api_name | ${prefix}-todo-api | API名 |
| endpoint_type | REGIONAL | エンドポイントタイプ |
| description | Todo API for ${environment} environment | API説明 |

## CORS設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| cors_allowed_origins | ["*"] | 許可するオリジン |
| cors_allowed_methods | ["GET", "POST", "PUT", "DELETE", "OPTIONS"] | 許可するHTTPメソッド |
| cors_allowed_headers | ["Content-Type", "X-Amz-Date", "Authorization", "X-Api-Key", "X-Amz-Security-Token"] | 許可するヘッダー |

## リソース構成
| パス | メソッド | 統合先Lambda | 用途 |
| --- | --- | --- | --- |
| /todos | GET | ${prefix}-get-todos | TODO一覧取得 |
| /todos | POST | ${prefix}-create-todo | TODO作成 |
| /todos/{id} | PUT | ${prefix}-update-todo | TODO更新 |
| /todos/{id} | DELETE | ${prefix}-delete-todo | TODO削除 |
| /todos | OPTIONS | MOCK統合 | CORS プリフライト |
| /todos/{id} | OPTIONS | MOCK統合 | CORS プリフライト |

## Lambda統合設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| 統合タイプ | AWS_PROXY | Lambda プロキシ統合 |
| 統合HTTPメソッド | POST | Lambda統合では常にPOST |
| 認証 | NONE | 認証なし |

## APIレスポンス設定
| エンドポイント | ステータスコード | CORSヘッダー | 用途 |
| --- | --- | --- | --- |
| GET /todos | 200 | Access-Control-Allow-* | 成功レスポンス |
| POST /todos | 201 | Access-Control-Allow-* | 作成成功レスポンス |
| PUT /todos/{id} | 200 | Access-Control-Allow-* | 更新成功レスポンス |
| DELETE /todos/{id} | 204 | Access-Control-Allow-* | 削除成功レスポンス |
| OPTIONS /todos | 200 | Access-Control-Allow-* | CORS プリフライト |
| OPTIONS /todos/{id} | 200 | Access-Control-Allow-* | CORS プリフライト |

## デプロイメント設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| deployment依存関係 | 全統合リソース | デプロイ前の依存関係 |
| lifecycle | create_before_destroy | 無停止デプロイ |

## アクセス権限
| 対象 | 権限 | 用途 |
| --- | --- | --- |
| API Gateway | lambda:InvokeFunction | Lambda関数呼び出し |
| Statement ID | AllowExecutionFromAPIGateway | 権限識別子 |
| Source ARN | ${api_execution_arn}/*/*ワイルドカード | 全メソッド・リソースからのアクセス |

## 出力値
| 出力名 | 値 | 用途 |
| --- | --- | --- |
| api_gateway_invoke_url | https://{api-id}.execute-api.{region}.amazonaws.com/{stage} | API ベースURL |
| api_gateway_todos_endpoint | {invoke_url}/todos | TODOsエンドポイント |
| api_gateway_rest_api_id | REST API ID | 他リソースからの参照 |
| api_gateway_deployment_id | デプロイメントID | デプロイ識別 |

## バリデーション項目
| パラメータ | 制約 | エラーメッセージ |
| --- | --- | --- |
| api_gateway_stage_name | 空文字不可 | "API Gateway stage name must not be empty." |

## モック統合（OPTIONS）設定
| 項目 | 設定値 | 備考 |
| --- | --- | --- |
| 統合タイプ | MOCK | モック統合 |
| リクエストテンプレート | {"statusCode": 200} | 固定レスポンス |
| CORSヘッダー出力 | cors_allowed_* 変数から動的生成 | CORS設定の反映 |
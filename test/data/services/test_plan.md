# `api_client_test.dart` テスト計画

## 目標
`ApiClientImpl` のテストカバレッジ90%以上達成。
`mockito` を使用し、`riverpod_test` は使用しない。

## テスト対象
`ApiClientImpl` クラスとその関連メソッド、および `apiClientProvider`。

## モック化が必要な依存関係
*   `http.Client`: 実際のネットワークリクエストを防ぎ、テスト結果を予測可能にするため。
    *   `http.Response` もモック化し、様々なステータスコードとボディを返すように設定する。
*   `logger`: テスト中にログが出力されないようにモック化するか、ログレベルを設定する。

## テストケース

### 1. `ApiClientImpl` のコンストラクタと初期化
- [ ] `ApiClientImpl` が `http.Client` と `baseUrl` で正しく初期化されること。

### 2. HTTP GET リクエスト
- [ ] 正常系: 有効なエンドポイントに対するGETリクエストが成功し、期待される`Map<String, dynamic>`が返されること。
- [ ] 正常系: ヘッダーが正しくリクエストに付与されること。
- [ ] 正常系: クエリパラメータが正しくリクエストに付与されること。
- [ ] 異常系: 400 Bad Requestの場合に`BadRequestException`がスローされること。
- [ ] 異常系: 401 Unauthorizedの場合に`UnauthorizedException`がスローされること。
- [ ] 異常系: 403 Forbiddenの場合に`ForbiddenException`がスローされること。
- [ ] 異常系: 404 Not Foundの場合に`NotFoundException`がスローされること。
- [ ] 異常系: 405 Method Not Allowedの場合に`MethodNotAllowedException`がスローされること。
- [ ] 異常系: 500 Internal Server Errorの場合に`InternalServerErrorException`がスローされること。
- [ ] 異常系: その他のHTTPステータスコードの場合に`UnknownErrorException`がスローされること。

### 3. HTTP POST リクエスト
- [ ] 正常系: 有効なエンドポイントに対するPOSTリクエストが成功し、期待される`Map<String, dynamic>`が返されること。
- [ ] 正常系: リクエストボディとヘッダーが正しくリクエストに付与されること。
- [ ] 異常系: GETリクエストと同様のHTTPステータスコードによるエラーハンドリングが適切に行われること。

### 4. HTTP PUT リクエスト
- [ ] 正常系: 有効なエンドポイントに対するPUTリクエストが成功し、期待される`Map<String, dynamic>`が返されること。
- [ ] 正常系: リクエストボディとヘッダーが正しくリクエストに付与されること。
- [ ] 異常系: GETリクエストと同様のHTTPステータスコードによるエラーハンドリングが適切に行われること。

### 5. HTTP DELETE リクエスト
- [ ] 正常系: 有効なエンドポイントに対するDELETEリクエストが成功し、期待される`Map<String, dynamic>`が返されること。
- [ ] 異常系: GETリクエストと同様のHTTPステータスコードによるエラーハンドリングが適切に行われること。

### 6. URI構築 (`_buildUri`)
- [ ] クエリパラメータがない場合に正しいURIが構築されること。
- [ ] クエリパラメータがある場合に正しいURIが構築されること。
- [ ] 特殊文字を含むクエリパラメータが正しくエンコードされること。

### 7. エラーとリトライ処理 (`_safeApiCall` 関連)
- [ ] ネットワークエラー (`SocketException`) が発生した場合、指定されたリトライ回数だけリトライが行われること。
- [ ] リトライ後、最終的にネットワークエラーが解決した場合、リクエストが成功すること。
- [ ] 最大リトライ回数を超えてネットワークエラーが継続した場合、`NoInternetConnectionException`がスローされること。
- [ ] `http.ClientException`が発生した場合、`ApiClientException`がスローされること。
- [ ] 無効なJSONレスポンス（例: 空文字列、不正な形式）が返された場合、`FormatException`を`ApiClientException`として捕捉しスローすること。
- [ ] レスポンスボディが`Map<String, dynamic>`ではない場合、`FormatException`がスローされること。
- [ ] その他の予期せぬエラーが発生した場合、それが再スローされること。

### 8. `apiClientProvider` のテスト
- [ ] `apiClientProvider` が `ApiClientImpl` のインスタンスを正しく提供すること。
- [ ] 提供される `ApiClientImpl` が `baseUrlProvider` から取得したベースURLを使用していること。

## 実装手順 (テストファイル内)
1.  `mockito` を使用して `MockClient` クラスを作成する。
2.  各テストグループ (`group`) ごとに必要なモックを設定する。
3.  `setUp` メソッドでテストの初期設定（モックのインスタンス化など）を行う。
4.  各テストケース (`test`) を記述し、`expect` を用いてアサーションを行う。
5.  `ProviderContainer` を利用して `apiClientProvider` のテストを行う。

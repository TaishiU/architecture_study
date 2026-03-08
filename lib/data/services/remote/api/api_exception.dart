/// APIクライアントの操作中に発生する可能性のある一般的な例外を表す基底クラス。
class ApiClientException implements Exception {
  /// [ApiClientException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  /// [statusCode] : 例外に関連するHTTPステータスコード。
  ApiClientException(this.message, {this.statusCode});

  /// エラーメッセージ。
  final String message;

  /// HTTPステータスコード（オプション）。
  final int? statusCode;

  @override
  /// 例外の文字列表現を返します。
  String toString() {
    if (statusCode != null) {
      return 'ApiClientException: $message (Status Code: $statusCode)';
    }
    return 'ApiClientException: $message';
  }
}

/// 不正なリクエスト（HTTP 400）を示す例外。
class BadRequestException extends ApiClientException {
  /// [BadRequestException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  /// [statusCode] : 例外に関連するHTTPステータスコード。
  BadRequestException(String message, {int? statusCode})
    : super('Bad Request: $message', statusCode: statusCode ?? 400);
}

/// 未認証（HTTP 401）を示す例外。
class UnauthorizedException extends ApiClientException {
  /// [UnauthorizedException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  /// [statusCode] : 例外に関連するHTTPステータスコード。
  UnauthorizedException(String message, {int? statusCode})
    : super('Unauthorized: $message', statusCode: statusCode ?? 401);
}

/// アクセス拒否（HTTP 403）を示す例外。
class ForbiddenException extends ApiClientException {
  /// [ForbiddenException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  /// [statusCode] : 例外に関連するHTTPステータスコード。
  ForbiddenException(String message, {int? statusCode})
    : super('Forbidden: $message', statusCode: statusCode ?? 403);
}

/// リソースが見つからない（HTTP 404）を示す例外。
class NotFoundException extends ApiClientException {
  /// [NotFoundException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  /// [statusCode] : 例外に関連するHTTPステータスコード。
  NotFoundException(String message, {int? statusCode})
    : super('Not Found: $message', statusCode: statusCode ?? 404);
}

/// 許可されていないメソッド（HTTP 405）を示す例外。
class MethodNotAllowedException extends ApiClientException {
  /// [MethodNotAllowedException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  /// [statusCode] : 例外に関連するHTTPステータスコード。
  MethodNotAllowedException(String message, {int? statusCode})
    : super('Method Not Allowed: $message', statusCode: statusCode ?? 405);
}

/// サーバー内部エラー（HTTP 500）を示す例外。
class InternalServerErrorException extends ApiClientException {
  /// [InternalServerErrorException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  /// [statusCode] : 例外に関連するHTTPステータスコード。
  InternalServerErrorException(String message, {int? statusCode})
    : super('Internal Server Error: $message', statusCode: statusCode ?? 500);
}

/// インターネット接続がない場合に発生する例外。
class NoInternetConnectionException extends ApiClientException {
  /// [NoInternetConnectionException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  NoInternetConnectionException(String message)
    : super('No Internet Connection: $message');
}

/// その他の不明なエラーを示す例外。
class UnknownErrorException extends ApiClientException {
  /// [UnknownErrorException] のコンストラクタ。
  ///
  /// [message] : 例外に関する説明メッセージ。
  /// [statusCode] : 例外に関連するHTTPステータスコード。
  UnknownErrorException(String message, {int? statusCode})
    : super('Unknown Error: $message', statusCode: statusCode);
}

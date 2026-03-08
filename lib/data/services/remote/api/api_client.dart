import 'dart:convert';
import 'dart:io';

import 'package:architecture_study/data/services/remote/api/api_exception.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

/// APIクライアントのインスタンスを提供するプロバイダー。
///
/// このプロバイダーを使用すると、アプリケーションのどこからでもAPIクライアントにアクセスできます。
final baseUrlProvider = Provider<String>((ref) => 'https://dummyjson.com');

/// HTTPリクエストメソッドを定義する列挙型。
///
/// 各要素はHTTPメソッドの文字列値を持ちます。
enum Method {
  /// HTTP GETメソッド。
  get('GET'),

  /// HTTP POSTメソッド。
  post('POST'),

  /// HTTP PUTメソッド。
  put('PUT'),

  /// HTTP DELETEメソッド。
  delete('DELETE')
  ;

  const Method(this.value);

  /// メソッド名
  final String value;
}

/// APIクライアントのインスタンスを提供するプロバイダー。
final apiClientProvider = Provider<ApiClient>(
  (ref) {
    final client = http.Client();
    final baseUrl = ref.watch(baseUrlProvider);
    return ApiClientImpl(
      client,
      baseUrl: baseUrl,
    );
  },
);

/// API操作のための抽象クライアントインターフェース。
///
/// このインターフェースは、GET、POST、PUT、DELETEなどのHTTPメソッドを定義します。
abstract class ApiClient {
  /// 指定されたエンドポイントからリソースを取得します。
  ///
  /// [endpoint] : リソースのパス。
  /// [headers] : リクエストに含めるヘッダー。
  /// [queryParameters] : クエリパラメータ。
  /// 戻り値: レスポンスボディを表すマップ。
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  /// 指定されたエンドポイントにリソースを新規作成または送信します。
  ///
  /// [endpoint] : リソースのパス。
  /// [body] : リクエストボディ。
  /// [headers] : リクエストに含めるヘッダー。
  /// 戻り値: レスポンスボディを表すマップ。
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  });

  /// 指定されたエンドポイントのリソースを更新します。
  ///
  /// [endpoint] : リソースのパス。
  /// [body] : リクエストボディ。
  /// [headers] : リクエストに含めるヘッダー。
  /// 戻り値: レスポンスボディを表すマップ。
  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  });

  /// 指定されたエンドポイントのリソースを削除します。
  ///
  /// [endpoint] : リソースのパス。
  /// 戻り値: レスポンスボディを表すマップ。
  Future<Map<String, dynamic>> delete({
    required String endpoint,
  });
}

/// [ApiClient] の実装クラス。
///
/// HTTPリクエストを送信し、レスポンスを処理するための具体的なロジックを提供します。
class ApiClientImpl implements ApiClient {
  /// [ApiClientImpl] のコンストラクタ。
  ///
  /// [_client] : HTTPリクエストの送信に使用する [http.Client] インスタンス。
  /// [baseUrl] : APIのベースURL。デフォルトは `'https://dummyjson.com'`。
  /// [retryDelay] : リクエストが失敗した場合の再試行の間隔。デフォルトは1秒。
  /// [maxRetries] : リクエストが失敗した場合の最大再試行回数。デフォルトは3回。
  ApiClientImpl(
    this._client, {
    required this.baseUrl,
    this.retryDelay = const Duration(seconds: 1),
    this.maxRetries = 3,
  });

  /// HTTPリクエストの送信に使用されるHTTPクライアント。
  final http.Client _client;

  /// APIのベースURL。
  final String baseUrl;

  /// リクエストが失敗した場合の再試行の間隔。
  final Duration retryDelay;

  /// リクエストが失敗した場合の最大再試行回数。
  final int maxRetries;

  @override
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return _safeApiCall(
      method: Method.get,
      endpoint: endpoint,
      headers: headers,
      queryParameters: queryParameters,
    );
  }

  @override
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    return _safeApiCall(
      method: Method.post,
      endpoint: endpoint,
      headers: headers,
      requestBody: body,
    );
  }

  @override
  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    return _safeApiCall(
      method: Method.put,
      endpoint: endpoint,
      headers: headers,
      requestBody: body,
    );
  }

  @override
  Future<Map<String, dynamic>> delete({required String endpoint}) {
    return _safeApiCall(
      method: Method.delete,
      endpoint: endpoint,
    );
  }

  Uri _buildUri(String endpoint, {Map<String, dynamic>? queryParameters}) {
    final baseUri = Uri.parse(baseUrl);
    final uri = baseUri.resolve(endpoint);
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(
      queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<Map<String, dynamic>> _safeApiCall({
    required Method method,
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? requestBody,
  }) async {
    final uri = _buildUri(endpoint, queryParameters: queryParameters);

    // ロギング
    logger.d('APIリクエスト: ${method.value} $uri');
    if (headers != null && headers.isNotEmpty) {
      logger.d('リクエストヘッダー: $headers');
    }
    if (requestBody != null) {
      logger.d('リクエストボディ: $requestBody');
    }

    Exception? lastException;

    for (var i = 0; i <= maxRetries; i++) {
      try {
        logger.d('APIリクエスト試行 ${i + 1}/${maxRetries + 1}');

        late final http.Response response;
        switch (method) {
          case Method.get:
            response = await _client.get(uri, headers: headers);
          case Method.post:
            response = await _client.post(
              uri,
              headers: {
                ...?headers,
                'Content-Type': 'application/json',
              },
              body: requestBody != null ? jsonEncode(requestBody) : null,
            );
          case Method.put:
            response = await _client.put(
              uri,
              headers: {
                ...?headers,
                'Content-Type': 'application/json',
              },
              body: requestBody != null ? jsonEncode(requestBody) : null,
            );
          case Method.delete:
            response = await _client.delete(uri, headers: headers);
        }

        logger
          ..i('APIレスポンス受信: ステータスコード ${response.statusCode}')
          ..i('レスポンスボディ: ${response.body}');
        return _parseResponse(
          statusCode: response.statusCode,
          responseBody: response.body,
        );
      } on SocketException catch (error) {
        logger.w('ネットワークエラー: ${error.message}');
        lastException = NoInternetConnectionException(error.message);
        if (i < maxRetries) {
          logger.w('リトライします... (${retryDelay.inSeconds}秒後)'); // コンストラクタから取得
          await Future<void>.delayed(retryDelay); // コンストラクタから取得
        }
      } on http.ClientException catch (error) {
        logger.e('HTTPクライアントエラー: ${error.message}');
        throw ApiClientException('HTTP Client Error: ${error.message}');
      } on FormatException catch (error) {
        logger.e('レスポンス形式エラー: ${error.message}');
        throw ApiClientException('Bad response format: ${error.message}');
      } catch (error) {
        logger.e('予期せぬエラー: $error');
        rethrow;
      }
    }
    throw lastException!;
  }

  Map<String, dynamic> _parseResponse({
    required int statusCode,
    required String responseBody,
  }) {
    final decodedBody = json.decode(responseBody);
    if (decodedBody is! Map<String, dynamic>) {
      throw FormatException(
        'Unexpected response body format: Expected Map<String, dynamic>, '
        'but got ${decodedBody.runtimeType}',
      );
    }
    switch (statusCode) {
      case 200:
      case 201:
        return decodedBody;
      case 400:
        throw BadRequestException(
          decodedBody.toString(),
          statusCode: statusCode,
        );
      case 401:
        throw UnauthorizedException(
          decodedBody.toString(),
          statusCode: statusCode,
        );
      case 403:
        throw ForbiddenException(
          decodedBody.toString(),
          statusCode: statusCode,
        );
      case 404:
        throw NotFoundException(
          decodedBody.toString(),
          statusCode: statusCode,
        );
      case 405:
        throw MethodNotAllowedException(
          decodedBody.toString(),
          statusCode: statusCode,
        );
      case 500:
        throw InternalServerErrorException(
          decodedBody.toString(),
          statusCode: statusCode,
        );
      default:
        throw UnknownErrorException(
          'Http status $statusCode',
          statusCode: statusCode,
        );
    }
  }
}

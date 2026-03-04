import 'dart:convert';
import 'dart:io';

import 'package:architecture_study/data/services/api_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

/// APIクライアントのインスタンスを提供するプロバイダー。
///
/// このプロバイダーを使用すると、アプリケーションのどこからでもAPIクライアントにアクセスできます。
final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClientImpl(
    http.Client(),
  ),
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
  /// [client] : HTTPリクエストの送信に使用する [http.Client] インスタンス。
  /// [baseUrl] : APIのベースURL。デフォルトは `'https://dummyjson.com'`。
  ApiClientImpl(
    this._client, {
    this.baseUrl = 'https://dummyjson.com',
  });

  /// HTTPリクエストの送信に使用されるHTTPクライアント。
  final http.Client _client;

  /// APIのベースURL。
  final String baseUrl;

  @override
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) {
    return _safeApiCall(
      () async => _client.get(
        _buildUri(endpoint, queryParameters: queryParameters),
        headers: headers,
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    return _safeApiCall(
      () async => _client.post(
        _buildUri(endpoint),
        headers: headers,
        body: jsonEncode(body), // Convert body to JSON string
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    return _safeApiCall(
      () async => _client.put(
        _buildUri(endpoint),
        headers: headers,
        body: jsonEncode(body), // Convert body to JSON string
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> delete({required String endpoint}) {
    return _safeApiCall(
      () async => _client.delete(
        _buildUri(endpoint),
      ),
    );
  }

  Uri _buildUri(String endpoint, {Map<String, dynamic>? queryParameters}) {
    final uri = Uri.parse('$baseUrl/$endpoint');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(
      queryParameters: queryParameters.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );
  }

  Future<Map<String, dynamic>> _safeApiCall(
    Future<http.Response> Function() callback,
  ) async {
    try {
      final response = await callback();
      return _parseResponse(
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    } on SocketException catch (error) {
      throw NoInternetConnectionException(error.message);
    } on http.ClientException catch (error) {
      throw ApiClientException('HTTP Client Error: ${error.message}');
    } on FormatException catch (error) {
      throw ApiClientException('Bad response format: ${error.message}');
    }
  }

  Map<String, dynamic> _parseResponse({
    required int statusCode,
    required String responseBody,
  }) {
    final decodedBody = json.decode(responseBody);
    if (decodedBody is! Map<String, dynamic>) {
      throw FormatException(
        'Unexpected response format: Expected Map<String, dynamic>, but got ${decodedBody.runtimeType}',
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

import 'dart:convert';
import 'dart:io';

import 'package:architecture_study/data/services/api_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClientImpl(
    http.Client(),
  ),
);

abstract class ApiClient {
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  });

  Future<Map<String, dynamic>> delete({
    required String endpoint,
  });
}

class ApiClientImpl implements ApiClient {
  ApiClientImpl(
    this._client, {
    this.baseUrl = 'https://dummyjson.com',
  });

  final http.Client _client;
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

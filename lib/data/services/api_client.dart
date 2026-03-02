import 'dart:convert';
import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

typedef JsonMap = Map<String, dynamic>;
typedef JsonList = List<dynamic>;

JsonMap parseJsonMap(String input) => json.decode(input) as JsonMap;

JsonList parseJsonList(String input) => json.decode(input) as JsonList;

final apiClientProvider = Provider<ApiClient>((ref) => ApiClientImpl());

abstract class ApiClient {
  Future<String> get({
    required String endpoint,
    Map<String, String>? headers,
  });

  Future<String> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  });

  Future<String> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  });

  Future<String> delete({
    required String endpoint,
  });
}

class ApiClientImpl implements ApiClient {
  factory ApiClientImpl({
    String baseUrl = 'https://dummyjson.com',
  }) {
    return _instance ??= ApiClientImpl._internal(baseUrl);
  }

  ApiClientImpl._internal(this.baseUrl);

  final String baseUrl;
  static ApiClientImpl? _instance;

  @override
  Future<String> get({
    required String endpoint,
    Map<String, String>? headers,
  }) {
    return _safeApiCall(
      () async => http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
      ),
    );
  }

  @override
  Future<String> post({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    return _safeApiCall(
      () async => http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: body,
      ),
    );
  }

  @override
  Future<String> put({
    required String endpoint,
    required Map<String, dynamic> body,
    Map<String, String>? headers,
  }) {
    return _safeApiCall(
      () async => http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: headers,
        body: body,
      ),
    );
  }

  @override
  Future<String> delete({required String endpoint}) {
    return _safeApiCall(
      () async => http.delete(
        Uri.parse('$baseUrl/$endpoint'),
      ),
    );
  }

  Future<String> _safeApiCall(Function callback) async {
    try {
      // ignore: avoid_dynamic_calls
      final response = await callback() as http.Response;
      // logger.d('response.statusCode: ${response.statusCode}');
      // logger.d('response.body: ${response.body}');
      return _parseResponse(
        statusCode: response.statusCode,
        responseBody: response.body,
      );
    } on SocketException catch (error) {
      throw Exception('No Internet Connection: $error');
    } on HttpException catch (error) {
      throw Exception('HttpExceptionが発生: $error');
    }
  }

  String _parseResponse({
    required int statusCode,
    required String responseBody,
  }) {
    switch (statusCode) {
      case 200:
      case 201:
        return responseBody;
      case 400:
        throw Exception('400 Bad Request');
      case 401:
        throw Exception('401 Unauthorized');
      case 403:
        throw Exception('403 Forbidden');
      case 404:
        throw Exception('404 Not Found');
      case 405:
        throw Exception('405 Method Not Allowed');
      case 500:
        throw Exception('500 Internal Server Error');
      default:
        throw Exception('Http status $statusCode: unknown error');
    }
  }
}

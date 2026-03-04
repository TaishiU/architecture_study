// api_client_test.dart
import 'dart:convert';
import 'dart:io'; // dart:ioをインポート
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'package:architecture_study/data/services/api_client.dart';
import 'package:architecture_study/data/services/api_exception.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fake_async/fake_async.dart'; // fake_asyncを追加

// MockClientを生成するためのアノテーション
@GenerateMocks([http.Client])
import 'api_client_test.mocks.dart';

void main() {
  // MockClientのインスタンス
  late MockClient mockClient;
  // ApiClientImplのインスタンス
  late ApiClientImpl apiClient;
  // ProviderContainerのインスタンス
  late ProviderContainer container;

  setUp(() {
    mockClient = MockClient();
    // baseUrlProviderをオーバーライドして、テスト用のbaseUrlを設定
    container = ProviderContainer(
      overrides: [
        baseUrlProvider.overrideWithValue('http://test.com'),
      ],
    );
    apiClient = ApiClientImpl(
      mockClient,
      baseUrl: container.read(baseUrlProvider),
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('ApiClientImpl', () {
    test('ApiClientImplがhttp.ClientとbaseUrlで正しく初期化されること', () {
      expect(apiClient, isA<ApiClientImpl>());
      expect(apiClient.baseUrl, 'http://test.com');
    });

    test('GETリクエストが成功し、期待されるMap<String, dynamic>が返されること', () async {
      final responseBody = {'id': 1, 'name': 'Test Item'};
      when(
        mockClient.get(
          Uri.parse('http://test.com/endpoint?param1=value1'),
          headers: {'Content-Type': 'application/json'},
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(responseBody),
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      final result = await apiClient.get(
        endpoint: 'endpoint',
        queryParameters: {'param1': 'value1'},
        headers: {'Content-Type': 'application/json'},
      );

      expect(result, responseBody);
      verify(mockClient.get(
        Uri.parse('http://test.com/endpoint?param1=value1'),
        headers: {'Content-Type': 'application/json'},
      )).called(1);
    });

    test('GETリクエストで400 Bad Requestの場合にBadRequestExceptionがスローされること', () async {
      final errorBody = {'message': 'Bad Request'};
      when(
        mockClient.get(
          Uri.parse('http://test.com/bad_request'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          400,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'bad_request'),
        throwsA(isA<BadRequestException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/bad_request'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('GETリクエストで401 Unauthorizedの場合にUnauthorizedExceptionがスローされること', () async {
      final errorBody = {'message': 'Unauthorized'};
      when(
        mockClient.get(
          Uri.parse('http://test.com/unauthorized'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          401,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'unauthorized'),
        throwsA(isA<UnauthorizedException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/unauthorized'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('GETリクエストで403 Forbiddenの場合にForbiddenExceptionがスローされること', () async {
      final errorBody = {'message': 'Forbidden'};
      when(
        mockClient.get(
          Uri.parse('http://test.com/forbidden'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          403,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'forbidden'),
        throwsA(isA<ForbiddenException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/forbidden'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('GETリクエストで404 Not Foundの場合にNotFoundExceptionがスローされること', () async {
      final errorBody = {'message': 'Not Found'};
      when(
        mockClient.get(
          Uri.parse('http://test.com/not_found'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          404,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'not_found'),
        throwsA(isA<NotFoundException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/not_found'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('GETリクエストで405 Method Not Allowedの場合にMethodNotAllowedExceptionがスローされること', () async {
      final errorBody = {'message': 'Method Not Allowed'};
      when(
        mockClient.get(
          Uri.parse('http://test.com/method_not_allowed'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          405,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'method_not_allowed'),
        throwsA(isA<MethodNotAllowedException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/method_not_allowed'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('GETリクエストで500 Internal Server Errorの場合にInternalServerErrorExceptionがスローされること', () async {
      final errorBody = {'message': 'Internal Server Error'};
      when(
        mockClient.get(
          Uri.parse('http://test.com/internal_server_error'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          500,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'internal_server_error'),
        throwsA(isA<InternalServerErrorException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/internal_server_error'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('GETリクエストでその他のHTTPステータスコードの場合にUnknownErrorExceptionがスローされること', () async {
      final errorBody = {'message': 'Bad Gateway'};
      when(
        mockClient.get(
          Uri.parse('http://test.com/unknown_error'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          502,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'unknown_error'),
        throwsA(isA<UnknownErrorException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/unknown_error'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('POSTリクエストが成功し、期待されるMap<String, dynamic>が返されること', () async {
      final requestBody = {'title': 'foo', 'body': 'bar', 'userId': 1};
      final responseBody = {'id': 101, ...requestBody};
      when(
        mockClient.post(
          Uri.parse('http://test.com/posts'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(responseBody),
          201, // POSTの場合は201 Createdが一般的
          headers: {'content-type': 'application/json'},
        ),
      );

      final result = await apiClient.post(
        endpoint: 'posts',
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      expect(result, responseBody);
      verify(mockClient.post(
        Uri.parse('http://test.com/posts'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      )).called(1);
    });

    test('POSTリクエストで400 Bad Requestの場合にBadRequestExceptionがスローされること', () async {
      final requestBody = {'title': 'foo', 'body': 'bar', 'userId': 1};
      final errorBody = {'message': 'Bad Request'};
      when(
        mockClient.post(
          Uri.parse('http://test.com/bad_request'),
          headers: anyNamed('headers'),
          body: json.encode(requestBody),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          400,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.post(endpoint: 'bad_request', body: requestBody),
        throwsA(isA<BadRequestException>()),
      );
      verify(mockClient.post(
        Uri.parse('http://test.com/bad_request'),
        headers: anyNamed('headers'),
        body: json.encode(requestBody),
      )).called(1);
    });

    test('PUTリクエストが成功し、期待されるMap<String, dynamic>が返されること', () async {
      final requestBody = {'id': 1, 'title': 'updated title'};
      final responseBody = {'id': 1, 'title': 'updated title'};
      when(
        mockClient.put(
          Uri.parse('http://test.com/posts/1'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(requestBody),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(responseBody),
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      final result = await apiClient.put(
        endpoint: 'posts/1',
        body: requestBody,
        headers: {'Content-Type': 'application/json'},
      );

      expect(result, responseBody);
      verify(mockClient.put(
        Uri.parse('http://test.com/posts/1'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      )).called(1);
    });

    test('PUTリクエストで400 Bad Requestの場合にBadRequestExceptionがスローされること', () async {
      final requestBody = {'id': 1, 'title': 'updated title'};
      final errorBody = {'message': 'Bad Request'};
      when(
        mockClient.put(
          Uri.parse('http://test.com/bad_request/1'),
          headers: anyNamed('headers'),
          body: json.encode(requestBody),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          400,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.put(endpoint: 'bad_request/1', body: requestBody),
        throwsA(isA<BadRequestException>()),
      );
      verify(mockClient.put(
        Uri.parse('http://test.com/bad_request/1'),
        headers: anyNamed('headers'),
        body: json.encode(requestBody),
      )).called(1);
    });

    test('DELETEリクエストが成功し、期待されるMap<String, dynamic>が返されること', () async {
      final responseBody = {'message': 'Item deleted successfully'};
      when(
        mockClient.delete(
          Uri.parse('http://test.com/posts/1'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(responseBody),
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      final result = await apiClient.delete(
        endpoint: 'posts/1',
      );

      expect(result, responseBody);
      verify(mockClient.delete(
        Uri.parse('http://test.com/posts/1'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('DELETEリクエストで400 Bad Requestの場合にBadRequestExceptionがスローされること', () async {
      final errorBody = {'message': 'Bad Request'};
      when(
        mockClient.delete(
          Uri.parse('http://test.com/bad_request/1'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(errorBody),
          400,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.delete(endpoint: 'bad_request/1'),
        throwsA(isA<BadRequestException>()),
      );
      verify(mockClient.delete(
        Uri.parse('http://test.com/bad_request/1'),
        headers: anyNamed('headers'),
      )).called(1);
    });
    test('ネットワークエラー時にリトライが行われ、最終的にNoInternetConnectionExceptionがスローされること', () { // async を削除
      fakeAsync((async) { // fakeAsync ブロックで囲む
        when(
          mockClient.get(
            any,
            headers: anyNamed('headers'),
          ),
        ).thenAnswer((_) async => throw const SocketException('No Internet'));

        expect(
          () => apiClient.get(endpoint: 'retry_fail'),
          throwsA(isA<NoInternetConnectionException>()),
        );

        // リトライに必要な時間を進める
        async.elapse(const Duration(seconds: 1) * 3); // 3回の遅延をシミュレート
        // 初回呼び出しと3回のリトライで合計4回 get が呼ばれることを期待
        verify(mockClient.get(
          any,
          headers: anyNamed('headers'),
        )).called(4);
      });
    });
    test('ネットワークエラー後にリトライして成功すること', () async {
      final responseBody = {'id': 1, 'name': 'Test Item'};
      int callCount = 0; // callCountをthenAnswerのクロージャの外に移動
      when(
        mockClient.get(
          any, // 位置引数には any を使用
          headers: anyNamed('headers'), // 名前付き引数には anyNamed を使用
        ),
      ).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) { // 初回呼び出しの場合
          throw const SocketException('No Internet');
        }
        return http.Response(
          json.encode(responseBody),
          200,
          headers: {'content-type': 'application/json'},
        );
      });

      final result = await apiClient.get(endpoint: 'retry_success');

      expect(result, responseBody);
      // 初回とリトライ1回で計2回呼ばれる想定
      verify(mockClient.get(
        Uri.parse('http://test.com/retry_success'),
        headers: anyNamed('headers'),
      )).called(2);
    });

    test('http.ClientExceptionが発生した場合にApiClientExceptionがスローされること', () async {
      when(
        mockClient.get(
          Uri.parse('http://test.com/client_error'),
          headers: anyNamed('headers'),
        ),
      ).thenThrow(http.ClientException('Client Error'));

      expect(
        () => apiClient.get(endpoint: 'client_error'),
        throwsA(isA<ApiClientException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/client_error'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('無効なJSONレスポンスが返された場合にApiClientExceptionがスローされること', () async {
      when(
        mockClient.get(
          Uri.parse('http://test.com/invalid_json'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          'This is not a JSON string',
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'invalid_json'),
        throwsA(isA<ApiClientException>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/invalid_json'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('レスポンスボディがMap<String, dynamic>ではない場合にFormatExceptionがスローされること', () async {
      when(
        mockClient.get(
          Uri.parse('http://test.com/non_map_json'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          json.encode(['item1', 'item2']), // Mapではないリストを返す
          200,
          headers: {'content-type': 'application/json'},
        ),
      );

      expect(
        () => apiClient.get(endpoint: 'non_map_json'),
        throwsA(isA<ApiClientException>()), // FormatException ではなく ApiClientException を期待
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/non_map_json'),
        headers: anyNamed('headers'),
      )).called(1);
    });

    test('その他の予期せぬエラーが発生した場合にそれが再スローされること', () async {
      when(
        mockClient.get(
          Uri.parse('http://test.com/unexpected_error'),
          headers: anyNamed('headers'),
        ),
      ).thenAnswer((_) async => throw Exception('Unexpected error occurred'));

      expect(
        () => apiClient.get(endpoint: 'unexpected_error'),
        throwsA(isA<Exception>()),
      );
      verify(mockClient.get(
        Uri.parse('http://test.com/unexpected_error'),
        headers: anyNamed('headers'),
      )).called(1);
    });
  }); // ApiClientImpl groupの閉じ括弧

  group('apiClientProvider', () {
    test('apiClientProviderがApiClientImplのインスタンスを正しく提供すること', () {
      final providedClient = container.read(apiClientProvider);
      expect(providedClient, isA<ApiClientImpl>());
    });

    test('提供されるApiClientImplがbaseUrlProviderから取得したベースURLを使用していること', () {
      final providedClient = container.read(apiClientProvider) as ApiClientImpl;
      expect(providedClient.baseUrl, 'http://test.com');
    });
  }); // apiClientProvider groupの閉じ括弧
} // main関数の閉じ括弧

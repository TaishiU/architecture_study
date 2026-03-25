// import 'dart:convert';
// import 'dart:io';
//
// import 'package:architecture_study/data/services/remote/api/api_client.dart';
// import 'package:architecture_study/data/services/remote/api/api_exception.dart';
// import 'package:fake_async/fake_async.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
//
// // MockClientを生成するためのアノテーション
// @GenerateMocks([http.Client])
// import 'api_client_test.mocks.dart';
//
// const String testBaseUrl = 'http://test.com';
// const Map<String, String> jsonContentTypeHeader = {
//   'Content-Type': 'application/json',
// };
//
// void main() {
//   late MockClient mockClient;
//   late ApiClientImpl apiClient;
//   late ProviderContainer container;
//
//   setUp(() {
//     mockClient = MockClient();
//     container = ProviderContainer(
//       overrides: [
//         baseUrlProvider.overrideWithValue(testBaseUrl),
//       ],
//     );
//     apiClient = ApiClientImpl(
//       mockClient,
//       baseUrl: container.read(baseUrlProvider),
//     );
//   });
//
//   tearDown(() {
//     container.dispose();
//   });
//
//   group('ApiClientImpl', () {
//     test('ApiClientImplがhttp.ClientとbaseUrlで正しく初期化されること', () {
//       expect(apiClient, isA<ApiClientImpl>());
//       expect(apiClient.baseUrl, 'http://test.com');
//     });
//
//     test('GETリクエストが成功し、期待されるMap<String, dynamic>が返されること', () async {
//       final responseBody = {'id': 1, 'name': 'Test Item'};
//       when(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/endpoint?param1=value1'),
//           headers: jsonContentTypeHeader,
//         ),
//       ).thenAnswer(
//         (_) async => http.Response(
//           json.encode(responseBody),
//           200,
//           headers: {'content-type': 'application/json'},
//         ),
//       );
//
//       final result = await apiClient.get(
//         endpoint: 'endpoint',
//         queryParameters: {'param1': 'value1'},
//         headers: jsonContentTypeHeader,
//       );
//
//       expect(result, responseBody);
//       verify(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/endpoint?param1=value1'),
//           headers: jsonContentTypeHeader,
//         ),
//       ).called(1);
//     });
//
//     group('GETリクエストのHTTPエラーハンドリング', () {
//       final errorCases = [
//         (statusCode: 400, exceptionType: BadRequestException),
//         (statusCode: 401, exceptionType: UnauthorizedException),
//         (statusCode: 403, exceptionType: ForbiddenException),
//         (statusCode: 404, exceptionType: NotFoundException),
//         (statusCode: 405, exceptionType: MethodNotAllowedException),
//         (statusCode: 500, exceptionType: InternalServerErrorException),
//         (statusCode: 502, exceptionType: UnknownErrorException),
//         // その他のエラーとして502 Bad Gatewayを例に
//       ];
//
//       for (final errorCase in errorCases) {
//         test(
//           'HTTP ${errorCase.statusCode} の場合に'
//           '${errorCase.exceptionType}がスローされること',
//           () async {
//             final errorBody = {'message': 'Error ${errorCase.statusCode}'};
//             final endpoint = 'error_${errorCase.statusCode}';
//             when(
//               mockClient.get(
//                 Uri.parse('$testBaseUrl/$endpoint'),
//                 headers: anyNamed('headers'),
//               ),
//             ).thenAnswer(
//               (_) async => http.Response(
//                 json.encode(errorBody),
//                 errorCase.statusCode,
//                 headers: {'content-type': 'application/json'},
//               ),
//             );
//
//             expect(
//               () => apiClient.get(endpoint: endpoint),
//               throwsA(isA<ApiClientException>()),
//             );
//             verify(
//               mockClient.get(
//                 Uri.parse('$testBaseUrl/$endpoint'),
//                 headers: anyNamed('headers'),
//               ),
//             ).called(1);
//           },
//         );
//       }
//     });
//
//     test('POSTリクエストが成功し、期待されるMap<String, dynamic>が返されること', () async {
//       final requestBody = {'title': 'foo', 'body': 'bar', 'userId': 1};
//       final responseBody = {'id': 101, ...requestBody};
//       when(
//         mockClient.post(
//           Uri.parse('$testBaseUrl/posts'),
//           headers: jsonContentTypeHeader,
//           body: json.encode(requestBody),
//         ),
//       ).thenAnswer(
//         (_) async => http.Response(
//           json.encode(responseBody),
//           201, // POSTの場合は201 Createdが一般的
//           headers: {'content-type': 'application/json'},
//         ),
//       );
//
//       final result = await apiClient.post(
//         endpoint: 'posts',
//         body: requestBody,
//         headers: jsonContentTypeHeader,
//       );
//
//       expect(result, responseBody);
//       verify(
//         mockClient.post(
//           Uri.parse('$testBaseUrl/posts'),
//           headers: jsonContentTypeHeader,
//           body: json.encode(requestBody),
//         ),
//       ).called(1);
//     });
//
//     test('POSTリクエストで400 Bad Requestの場合にBadRequestExceptionがスローされること', () async {
//       final requestBody = {'title': 'foo', 'body': 'bar', 'userId': 1};
//       final errorBody = {'message': 'Bad Request'};
//       when(
//         mockClient.post(
//           Uri.parse('$testBaseUrl/bad_request'),
//           headers: anyNamed('headers'),
//           body: json.encode(requestBody),
//         ),
//       ).thenAnswer(
//         (_) async => http.Response(
//           json.encode(errorBody),
//           400,
//           headers: {'content-type': 'application/json'},
//         ),
//       );
//
//       expect(
//         () => apiClient.post(endpoint: 'bad_request', body: requestBody),
//         throwsA(isA<BadRequestException>()),
//       );
//       verify(
//         mockClient.post(
//           Uri.parse('$testBaseUrl/bad_request'),
//           headers: anyNamed('headers'),
//           body: json.encode(requestBody),
//         ),
//       ).called(1);
//     });
//
//     test('PUTリクエストが成功し、期待されるMap<String, dynamic>が返されること', () async {
//       final requestBody = {'id': 1, 'title': 'updated title'};
//       final responseBody = {'id': 1, 'title': 'updated title'};
//       when(
//         mockClient.put(
//           Uri.parse('$testBaseUrl/posts/1'),
//           headers: jsonContentTypeHeader,
//           body: json.encode(requestBody),
//         ),
//       ).thenAnswer(
//         (_) async => http.Response(
//           json.encode(responseBody),
//           200,
//           headers: {'content-type': 'application/json'},
//         ),
//       );
//
//       final result = await apiClient.put(
//         endpoint: 'posts/1',
//         body: requestBody,
//         headers: jsonContentTypeHeader,
//       );
//
//       expect(result, responseBody);
//       verify(
//         mockClient.put(
//           Uri.parse('$testBaseUrl/posts/1'),
//           headers: jsonContentTypeHeader,
//           body: json.encode(requestBody),
//         ),
//       ).called(1);
//     });
//
//     test('PUTリクエストで400 Bad Requestの場合にBadRequestExceptionがスローされること', () async {
//       final requestBody = {'id': 1, 'title': 'updated title'};
//       final errorBody = {'message': 'Bad Request'};
//       when(
//         mockClient.put(
//           Uri.parse('$testBaseUrl/bad_request/1'),
//           headers: anyNamed('headers'),
//           body: json.encode(requestBody),
//         ),
//       ).thenAnswer(
//         (_) async => http.Response(
//           json.encode(errorBody),
//           400,
//           headers: {'content-type': 'application/json'},
//         ),
//       );
//
//       expect(
//         () => apiClient.put(endpoint: 'bad_request/1', body: requestBody),
//         throwsA(isA<BadRequestException>()),
//       );
//       verify(
//         mockClient.put(
//           Uri.parse('$testBaseUrl/bad_request/1'),
//           headers: anyNamed('headers'),
//           body: json.encode(requestBody),
//         ),
//       ).called(1);
//     });
//
//     test('DELETEリクエストが成功し、期待されるMap<String, dynamic>が返されること', () async {
//       final responseBody = {'message': 'Item deleted successfully'};
//       when(
//         mockClient.delete(
//           Uri.parse('$testBaseUrl/posts/1'),
//           headers: anyNamed('headers'),
//         ),
//       ).thenAnswer(
//         (_) async => http.Response(
//           json.encode(responseBody),
//           200,
//           headers: {'content-type': 'application/json'},
//         ),
//       );
//
//       final result = await apiClient.delete(
//         endpoint: 'posts/1',
//       );
//
//       expect(result, responseBody);
//       verify(
//         mockClient.delete(
//           Uri.parse('$testBaseUrl/posts/1'),
//           headers: anyNamed('headers'),
//         ),
//       ).called(1);
//     });
//
//     test(
//       'DELETEリクエストで400 Bad Requestの場合にBadRequestExceptionがスローされること',
//       () async {
//         final errorBody = {'message': 'Bad Request'};
//         when(
//           mockClient.delete(
//             Uri.parse('$testBaseUrl/bad_request/1'),
//             headers: anyNamed('headers'),
//           ),
//         ).thenAnswer(
//           (_) async => http.Response(
//             json.encode(errorBody),
//             400,
//             headers: {'content-type': 'application/json'},
//           ),
//         );
//
//         expect(
//           () => apiClient.delete(endpoint: 'bad_request/1'),
//           throwsA(isA<BadRequestException>()),
//         );
//         verify(
//           mockClient.delete(
//             Uri.parse('$testBaseUrl/bad_request/1'),
//             headers: anyNamed('headers'),
//           ),
//         ).called(1);
//       },
//     );
//
//     test(
//       'ネットワークエラー時にリトライが行われ、最終的にNoInternetConnectionExceptionがスローされること',
//       () async {
//         fakeAsync((async) {
//           when(
//             mockClient.get(
//               any,
//               headers: anyNamed('headers'),
//             ),
//           ).thenAnswer((_) async => throw const SocketException('No Internet'));
//
//           // APIコールをバックグラウンドで開始し、そのFutureを保持
//           final future = apiClient.get(endpoint: 'retry_fail');
//
//           // 期待される例外がスローされることをアサート
//           expect(
//             future,
//             throwsA(isA<NoInternetConnectionException>()),
//           );
//
//           // _safeApiCallはmaxRetries=3なので、初回+3リトライで合計4回試行される。
//           // 3回のリトライそれぞれでretryDelayが挟まるため、3回分の遅延を進める
//           for (var i = 0; i < apiClient.maxRetries; i++) {
//             async.elapse(apiClient.retryDelay); // 各リトライ遅延を進める
//           }
//
//           // microtaskキューをフラッシュして、全ての非同期処理が完了するのを待つ
//           async.flushMicrotasks();
//
//           // 最終的なverify: 初回と3回のリトライで合計4回呼ばれる
//           verify(
//             mockClient.get(
//               Uri.parse('$testBaseUrl/retry_fail'),
//               headers: anyNamed('headers'),
//             ),
//           ).called(apiClient.maxRetries + 1);
//         });
//       },
//     );
//
//     test('ネットワークエラー後にリトライして成功すること', () async {
//       final responseBody = {'id': 1, 'name': 'Test Item'};
//       var callCount = 0; // callCountをthenAnswerのクロージャの外に移動
//       when(
//         mockClient.get(
//           any, // 位置引数には any を使用
//           headers: anyNamed('headers'), // 名前付き引数には anyNamed を使用
//         ),
//       ).thenAnswer((_) async {
//         callCount++;
//         if (callCount == 1) {
//           // 初回呼び出しの場合
//           throw const SocketException('No Internet');
//         }
//         return http.Response(
//           json.encode(responseBody),
//           200,
//           headers: {'content-type': 'application/json'},
//         );
//       });
//
//       final result = await apiClient.get(endpoint: 'retry_success');
//
//       expect(result, responseBody);
//       // 初回とリトライ1回で計2回呼ばれる想定
//       verify(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/retry_success'), // 定数を使用
//           headers: anyNamed('headers'),
//         ),
//       ).called(2);
//     });
//
//     test('http.ClientExceptionが発生した場合にApiClientExceptionがスローされること', () async {
//       when(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/client_error'),
//           headers: anyNamed('headers'),
//         ),
//       ).thenThrow(http.ClientException('Client Error'));
//
//       expect(
//         () => apiClient.get(endpoint: 'client_error'),
//         throwsA(isA<ApiClientException>()),
//       );
//       verify(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/client_error'),
//           headers: anyNamed('headers'),
//         ),
//       ).called(1);
//     });
//
//     test('無効なJSONレスポンスが返された場合にApiClientExceptionがスローされること', () async {
//       when(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/invalid_json'),
//           headers: anyNamed('headers'),
//         ),
//       ).thenAnswer(
//         (_) async => http.Response(
//           'This is not a JSON string',
//           200,
//           headers: {'content-type': 'application/json'},
//         ),
//       );
//
//       expect(
//         () => apiClient.get(endpoint: 'invalid_json'),
//         throwsA(isA<ApiClientException>()),
//       );
//       verify(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/invalid_json'),
//           headers: anyNamed('headers'),
//         ),
//       ).called(1);
//     });
//
//     test(
//       'レスポンスボディがMap<String, dynamic>ではない場合にApiClientExceptionがスローされること',
//       () async {
//         when(
//           mockClient.get(
//             Uri.parse('$testBaseUrl/non_map_json'),
//             headers: anyNamed('headers'),
//           ),
//         ).thenAnswer(
//           (_) async => http.Response(
//             json.encode(['item1', 'item2']), // Mapではないリストを返す
//             200,
//             headers: {'content-type': 'application/json'},
//           ),
//         );
//
//         expect(
//           () => apiClient.get(endpoint: 'non_map_json'),
//           throwsA(
//             isA<ApiClientException>(),
//           ), // FormatException ではなく ApiClientException を期待
//         );
//         verify(
//           mockClient.get(
//             Uri.parse('$testBaseUrl/non_map_json'),
//             headers: anyNamed('headers'),
//           ),
//         ).called(1);
//       },
//     );
//
//     test('その他の予期せぬエラーが発生した場合にそれが再スローされること', () async {
//       when(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/unexpected_error'),
//           headers: anyNamed('headers'),
//         ),
//       ).thenAnswer((_) async => throw Exception('Unexpected error occurred'));
//
//       expect(
//         () => apiClient.get(endpoint: 'unexpected_error'),
//         throwsA(isA<Exception>()),
//       );
//       verify(
//         mockClient.get(
//           Uri.parse('$testBaseUrl/unexpected_error'),
//           headers: anyNamed('headers'),
//         ),
//       ).called(1);
//     });
//   }); // ApiClientImpl groupの閉じ括弧
//
//   group('apiClientProvider', () {
//     test('apiClientProviderがApiClientImplのインスタンスを正しく提供すること', () {
//       final providedClient = container.read(apiClientProvider);
//       expect(providedClient, isA<ApiClientImpl>());
//     });
//
//     test('提供されるApiClientImplがbaseUrlProviderから取得したベースURLを使用していること', () {
//       final providedClient = container.read(apiClientProvider) as ApiClientImpl;
//       expect(providedClient.baseUrl, 'http://test.com');
//     });
//   }); // apiClientProvider groupの閉じ括弧
// } // main関数の閉じ括弧

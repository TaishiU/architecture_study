import 'package:architecture_study/data/models/todos/todos_model.dart';
import 'package:architecture_study/data/services/api_client.dart';
import 'package:architecture_study/data/services/api_exception.dart';
import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/data/services/todos/todos_service_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'todos_service_api_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  // todoServiceAPIProviderのテスト
  group('todoServiceAPIProvider', () {
    late ProviderContainer container;
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
      container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(mockApiClient),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('todoServiceAPIProviderはTodoServiceAPIのインスタンスを返すこと', () {
      final service = container.read(todoServiceAPIProvider);
      expect(service, isA<TodoServiceAPI>());
    });

    test('todoServiceAPIProviderは指定されたApiClientで初期化されること', () async {
      // todoServiceAPIProviderがmockApiClientで初期化されていることを確認するために、
      // serviceのfetchメソッドを呼び出し、mockApiClientのgetメソッドが呼ばれることを検証する。
      final service = container.read(todoServiceAPIProvider);
      when(mockApiClient.get(endpoint: 'todos')).thenAnswer(
        (_) async => {'todos': <Map<String, dynamic>>[]},
      );
      await service.fetch();
      verify(mockApiClient.get(endpoint: 'todos')).called(1);
    });
  });

  late MockApiClient mockApiClient;
  late TodoServiceAPI todoServiceAPI;

  setUp(() {
    mockApiClient = MockApiClient();
    todoServiceAPI = TodoServiceAPI(apiClient: mockApiClient);
  });

  // fetchメソッドのテスト
  group('fetch', () {
    test('todosの取得に成功した場合、SuccessResultを返すこと', () async {
      final mockResponse = {
        'todos': [
          {'id': 1, 'userId': 1, 'todo': 'Test Todo 1', 'completed': false},
          {'id': 2, 'userId': 1, 'todo': 'Test Todo 2', 'completed': true},
        ],
      };
      when(
        mockApiClient.get(endpoint: 'todos'),
      ).thenAnswer((_) async => mockResponse);

      final result = await todoServiceAPI.fetch();

      expect(result, isA<SuccessResult<TodosModel>>());
      expect((result as SuccessResult<TodosModel>).value.todos?.length, 2);
      expect(result.value.todos?[0].todo, 'Test Todo 1');
    });

    test('ApiClientExceptionが発生した場合、FailureResultを返すこと', () async {
      final apiException = ApiClientException('Not Found', statusCode: 404);
      when(mockApiClient.get(endpoint: 'todos')).thenThrow(apiException);

      final result = await todoServiceAPI.fetch();

      expect(result, isA<FailureResult<TodosModel>>());
      expect((result as FailureResult<TodosModel>).error, apiException);
    });

    test('その他の例外が発生した場合、FailureResultを返すこと', () async {
      final exception = Exception('Something went wrong');
      when(mockApiClient.get(endpoint: 'todos')).thenThrow(exception);

      final result = await todoServiceAPI.fetch();

      expect(result, isA<FailureResult<TodosModel>>());
      expect((result as FailureResult<TodosModel>).error, exception);
    });
  });

  // fetchByIdメソッドのテスト
  group('fetchById', () {
    test('指定されたIDのTODOの取得に成功した場合、SuccessResultを返すこと', () async {
      const todoId = 1;
      final mockResponse = {
        'id': todoId,
        'userId': 1,
        'todo': 'Test Todo 1',
        'completed': false,
      };
      when(
        mockApiClient.get(endpoint: 'todos/$todoId'),
      ).thenAnswer((_) async => mockResponse);

      final result = await todoServiceAPI.fetchById(id: todoId);

      expect(result, isA<SuccessResult<TodoModel>>());
      expect((result as SuccessResult<TodoModel>).value.id, todoId);
      expect(result.value.todo, 'Test Todo 1');
    });

    test('ApiClientExceptionが発生した場合、FailureResultを返すこと', () async {
      const todoId = 1;
      final apiException = ApiClientException('Not Found', statusCode: 404);
      when(
        mockApiClient.get(endpoint: 'todos/$todoId'),
      ).thenThrow(apiException);

      final result = await todoServiceAPI.fetchById(id: todoId);

      expect(result, isA<FailureResult<TodoModel>>());
      expect((result as FailureResult<TodoModel>).error, apiException);
    });

    test('その他の例外が発生した場合、FailureResultを返すこと', () async {
      const todoId = 1;
      final exception = Exception('Something went wrong');
      when(mockApiClient.get(endpoint: 'todos/$todoId')).thenThrow(exception);

      final result = await todoServiceAPI.fetchById(id: todoId);

      expect(result, isA<FailureResult<TodoModel>>());
      expect((result as FailureResult<TodoModel>).error, exception);
    });
  });
}

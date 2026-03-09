import 'package:architecture_study/data/services/remote/api/api_client.dart';
import 'package:architecture_study/data/services/remote/api/api_exception.dart';
import 'package:architecture_study/data/services/remote/api/todos/todos_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/todos/todos_dto.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'todos_api_service_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late TodosApiServiceImpl todosApiServiceImpl;

  setUp(() {
    mockApiClient = MockApiClient();
    todosApiServiceImpl = TodosApiServiceImpl(apiClient: mockApiClient);
  });

  // todosApiServiceImplProviderのテスト
  group('todosApiServiceImplProvider', () {
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

    test('todosApiServiceImplProviderはTodosApiServiceImplのインスタンスを返すこと', () {
      final service = container.read(todosApiServiceImplProvider);
      expect(service, isA<TodosApiServiceImpl>());
    });

    test('todosApiServiceImplProviderは指定されたApiClientで初期化されること', () async {
      // todosApiServiceImplProviderがmockApiClientで初期化されていることを確認するために、
      // serviceのfetchメソッドを呼び出し、mockApiClientのgetメソッドが呼ばれることを検証する。
      final service = container.read(todosApiServiceImplProvider);
      when(mockApiClient.get(endpoint: 'todos')).thenAnswer(
        (_) async => {'todos': <Map<String, dynamic>>[]},
      );
      await service.fetch();
      verify(mockApiClient.get(endpoint: 'todos')).called(1);
    });
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

      final result = await todosApiServiceImpl.fetch();

      expect(result, isA<SuccessResult<TodosDto>>());
      expect((result as SuccessResult<TodosDto>).value.todos?.length, 2);
      expect(result.value.todos?[0].todo, 'Test Todo 1');
    });

    test('ApiClientExceptionが発生した場合、FailureResultを返すこと', () async {
      final apiException = ApiClientException('Not Found', statusCode: 404);
      when(mockApiClient.get(endpoint: 'todos')).thenThrow(apiException);

      final result = await todosApiServiceImpl.fetch();

      expect(result, isA<FailureResult<TodosDto>>());
      expect((result as FailureResult<TodosDto>).error, apiException);
    });

    test('その他の例外が発生した場合、FailureResultを返すこと', () async {
      final exception = Exception('Something went wrong');
      when(mockApiClient.get(endpoint: 'todos')).thenThrow(exception);

      final result = await todosApiServiceImpl.fetch();

      expect(result, isA<FailureResult<TodosDto>>());
      expect((result as FailureResult<TodosDto>).error, exception);
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

      final result = await todosApiServiceImpl.fetchById(id: todoId);

      expect(result, isA<SuccessResult<TodoDto>>());
      expect((result as SuccessResult<TodoDto>).value.id, todoId);
      expect(result.value.todo, 'Test Todo 1');
    });

    test('ApiClientExceptionが発生した場合、FailureResultを返すこと', () async {
      const todoId = 1;
      final apiException = ApiClientException('Not Found', statusCode: 404);
      when(
        mockApiClient.get(endpoint: 'todos/$todoId'),
      ).thenThrow(apiException);

      final result = await todosApiServiceImpl.fetchById(id: todoId);

      expect(result, isA<FailureResult<TodoDto>>());
      expect((result as FailureResult<TodoDto>).error, apiException);
    });

    test('その他の例外が発生した場合、FailureResultを返すこと', () async {
      const todoId = 1;
      final exception = Exception('Something went wrong');
      when(mockApiClient.get(endpoint: 'todos/$todoId')).thenThrow(exception);

      final result = await todosApiServiceImpl.fetchById(id: todoId);

      expect(result, isA<FailureResult<TodoDto>>());
      expect((result as FailureResult<TodoDto>).error, exception);
    });
  });
}

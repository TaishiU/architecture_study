import 'package:architecture_study/data/repositories/todos/todo_repository.dart';
import 'package:architecture_study/data/services/models/todos/todos_model.dart';
import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/data/services/todos/todos_service.dart';
import 'package:architecture_study/data/services/todos/todos_service_api.dart'; // todoServiceAPIProviderのために追加
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'todo_repository_test.mocks.dart';

// MissingDummyValueErrorを解決するためにダミー値を提供するヘルパー関数
void _setupDummyValues() {
  provideDummyBuilder<Result<TodosModel>>(
    (_, _) => const SuccessResult(TodosModel(todos: [])),
  );
  provideDummyBuilder<Result<TodoModel>>(
    (_, _) => const SuccessResult(TodoModel()),
  );
}

@GenerateMocks([TodosService, TodoServiceAPI])
void main() {
  _setupDummyValues(); // main関数の先頭でダミー値をセットアップ

  // todoRepositoryProviderのテスト
  group('todoRepositoryProvider', () {
    late ProviderContainer container;
    late MockTodoServiceAPI mockTodoServiceAPI;

    setUp(() {
      mockTodoServiceAPI = MockTodoServiceAPI();
      // todoServiceAPIProviderをモックするoverrideを設定してProviderContainerを初期化
      container = ProviderContainer(
        overrides: [
          todoServiceAPIProvider.overrideWith((ref) => mockTodoServiceAPI),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('todoRepositoryProviderはTodoRepositoryAPIのインスタンスを返すこと', () {
      final repository = container.read(todoRepositoryProvider);
      expect(repository, isA<TodoRepository>());
    });

    test('todoRepositoryProviderは指定されたTodosServiceで初期化されること', () async {
      final repository = container.read(todoRepositoryProvider);

      // モックされたfetchメソッドを呼び出すことで、
      // 内部で渡されたTodosServiceが使用されていることを確認
      when(mockTodoServiceAPI.fetch()).thenAnswer(
        (_) async => const SuccessResult(TodosModel(todos: [])),
      );
      await repository.fetch();
      verify(mockTodoServiceAPI.fetch()).called(1);
    });
  });

  late MockTodosService mockTodosService;
  late TodoRepository todoRepository;

  setUp(() {
    mockTodosService = MockTodosService();
    todoRepository = TodoRepository(todoService: mockTodosService);
  });

  // fetchメソッドのテスト
  group('fetch', () {
    test(
      'TodosServiceがSuccessResultを返した場合、Todoエンティティに変換してSuccessResultを返すこと',
      () async {
        final mockTodoModels = [
          const TodoModel(userId: 1, id: 1, todo: 'Todo 1', completed: false),
          const TodoModel(userId: 1, id: 2, todo: 'Todo 2', completed: true),
        ];
        final mockTodosModel = TodosModel(todos: mockTodoModels);
        when(mockTodosService.fetch()).thenAnswer(
          (_) async => SuccessResult(mockTodosModel),
        );

        final result = await todoRepository.fetch();

        expect(result, isA<SuccessResult<Todos>>());
        expect((result as SuccessResult<Todos>).value.todos.length, 2);
        expect(result.value.todos[0].id, 1);
        expect(result.value.todos[1].todo, 'Todo 2');
        verify(mockTodosService.fetch()).called(1);
      },
    );

    test('TodosServiceがFailureResultを返した場合、FailureResultを返すこと', () async {
      final exception = Exception('API Error');
      when(mockTodosService.fetch()).thenAnswer(
        (_) async => FailureResult(exception),
      );

      final result = await todoRepository.fetch();

      expect(result, isA<FailureResult<Todos>>());
      expect((result as FailureResult<Todos>).error, exception);
      verify(mockTodosService.fetch()).called(1);
    });

    test('TodosServiceが例外をスローした場合、FailureResultを返すこと', () async {
      final exception = Exception('Network Error');
      when(mockTodosService.fetch()).thenThrow(exception);

      final result = await todoRepository.fetch();

      expect(result, isA<FailureResult<Todos>>());
      expect((result as FailureResult<Todos>).error, exception);
      verify(mockTodosService.fetch()).called(1);
    });

    test('TodoModelの必須フィールドが欠損している場合、そのTodoはスキップされること', () async {
      final mockTodoModels = [
        const TodoModel(userId: 1, id: 1, todo: 'Todo 1', completed: false),
        const TodoModel(id: 2, todo: 'Todo 2', completed: true), // userId欠損
        const TodoModel(userId: 3, todo: 'Todo 3', completed: false), // id欠損
        const TodoModel(userId: 4, id: 4), // その他が欠損
      ];
      final mockTodosModel = TodosModel(todos: mockTodoModels);
      when(mockTodosService.fetch()).thenAnswer(
        (_) async => SuccessResult(mockTodosModel),
      );

      final result = await todoRepository.fetch();

      expect(result, isA<SuccessResult<Todos>>());
      expect((result as SuccessResult<Todos>).value.todos.length, 2);
      expect(result.value.todos[0].id, 1);
      expect(result.value.todos[1].id, 4);
      verify(mockTodosService.fetch()).called(1);
    });

    test('TodoModelのフィールドがnullの場合、デフォルト値が与えられること', () async {
      final mockTodoModels = [
        const TodoModel(userId: 4, id: 4), // userIdとid以外がnull
      ];
      final mockTodosModel = TodosModel(todos: mockTodoModels);
      when(mockTodosService.fetch()).thenAnswer(
        (_) async => SuccessResult(mockTodosModel),
      );

      final result = await todoRepository.fetch();

      expect(result, isA<SuccessResult<Todos>>());
      expect((result as SuccessResult<Todos>).value.todos.length, 1);
      expect(result.value.todos[0].todo, isEmpty);
      expect(result.value.todos[0].completed, isFalse);
      verify(mockTodosService.fetch()).called(1);
    });
  });

  // fetchByIdメソッドのテスト
  group('fetchById', () {
    test(
      'TodosServiceがSuccessResultを返した場合、Todoエンティティに変換してSuccessResultを返すこと',
      () async {
        const mockTodoModel = TodoModel(
          userId: 1,
          id: 1,
          todo: 'Test Todo',
          completed: false,
        );
        when(mockTodosService.fetchById(id: 1)).thenAnswer(
          (_) async => const SuccessResult(mockTodoModel),
        );

        final result = await todoRepository.fetchById(id: 1);

        expect(result, isA<SuccessResult<Todo>>());
        expect((result as SuccessResult<Todo>).value.id, 1);
        expect(result.value.todo, 'Test Todo');
        verify(mockTodosService.fetchById(id: 1)).called(1);
      },
    );

    test('TodosServiceがFailureResultを返した場合、FailureResultを返すこと', () async {
      final exception = Exception('API Error');
      when(mockTodosService.fetchById(id: 1)).thenAnswer(
        (_) async => FailureResult(exception),
      );

      final result = await todoRepository.fetchById(id: 1);

      expect(result, isA<FailureResult<Todo>>());
      expect((result as FailureResult<Todo>).error, exception);
      verify(mockTodosService.fetchById(id: 1)).called(1);
    });

    test('TodosServiceが例外をスローした場合、FailureResultを返すこと', () async {
      final exception = Exception('Network Error');
      when(mockTodosService.fetchById(id: 1)).thenThrow(exception);

      final result = await todoRepository.fetchById(id: 1);

      expect(result, isA<FailureResult<Todo>>());
      expect((result as FailureResult<Todo>).error, exception);
      verify(mockTodosService.fetchById(id: 1)).called(1);
    });

    test('TodoModelの必須フィールドが欠損している場合、fetchByIdがFailureResultを返すこと', () async {
      // userIdとidが欠損
      const mockTodoModel = TodoModel(
        todo: 'Test Todo',
        completed: false,
      );
      when(mockTodosService.fetchById(id: 1)).thenAnswer(
        (_) async => const SuccessResult(mockTodoModel),
      );

      final result = await todoRepository.fetchById(id: 1);

      expect(result, isA<FailureResult<Todo>>());
      final failure = result as FailureResult<Todo>;
      expect(failure.error, isA<Exception>());
      expect(
        failure.error.toString(),
        'Exception: Required fields missing for Todo with ID 1',
      );
      verify(mockTodosService.fetchById(id: 1)).called(1);
    });
  });
}

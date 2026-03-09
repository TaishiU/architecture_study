import 'package:architecture_study/data/repositories/todos/todo_repository.dart';
import 'package:architecture_study/data/services/remote/api/todos/todos_api_service.dart';
import 'package:architecture_study/data/services/remote/api/todos/todos_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/todos/todos_dto.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'todo_repository_test.mocks.dart';

// MissingDummyValueErrorを解決するためにダミー値を提供するヘルパー関数
void _setupDummyValues() {
  provideDummyBuilder<Result<TodosDto>>(
    (_, _) => const SuccessResult(TodosDto(todos: [])),
  );
  provideDummyBuilder<Result<TodoDto>>(
    (_, _) => const SuccessResult(TodoDto()),
  );
}

@GenerateMocks([TodosApiService, TodosApiServiceImpl])
void main() {
  _setupDummyValues(); // main関数の先頭でダミー値をセットアップ

  late MockTodosApiService mockTodosApiService;
  late TodoRepository todoRepository;

  setUp(() {
    mockTodosApiService = MockTodosApiService();
    todoRepository = TodoRepository(todoApiService: mockTodosApiService);
  });

  // todoRepositoryProviderのテスト
  group('todoRepositoryProvider', () {
    late ProviderContainer container;
    late MockTodosApiServiceImpl mockTodosApiServiceImpl;

    setUp(() {
      mockTodosApiServiceImpl = MockTodosApiServiceImpl();
      // todosApiServiceImplProviderをモックするoverrideを設定してProviderContainerを初期化
      container = ProviderContainer(
        overrides: [
          todosApiServiceImplProvider.overrideWith(
            (ref) => mockTodosApiServiceImpl,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('todoRepositoryProviderはTodoRepositoryのインスタンスを返すこと', () {
      final repository = container.read(todoRepositoryProvider);
      expect(repository, isA<TodoRepository>());
    });

    test('todoRepositoryProviderは指定されたTodosApiServiceで初期化されること', () async {
      final repository = container.read(todoRepositoryProvider);

      // モックされたfetchメソッドを呼び出すことで、
      // 内部で渡されたTodosServiceが使用されていることを確認
      when(mockTodosApiServiceImpl.fetch()).thenAnswer(
        (_) async => const SuccessResult(TodosDto(todos: [])),
      );
      await repository.fetch();
      verify(mockTodosApiServiceImpl.fetch()).called(1);
    });
  });

  // fetchメソッドのテスト
  group('fetch', () {
    test(
      'TodosServiceがSuccessResultを返した場合、Todoエンティティに変換してSuccessResultを返すこと',
      () async {
        final mockTodoDtos = [
          const TodoDto(userId: 1, id: 1, todo: 'Todo 1', completed: false),
          const TodoDto(userId: 1, id: 2, todo: 'Todo 2', completed: true),
        ];
        final mockTodosDto = TodosDto(todos: mockTodoDtos);
        when(mockTodosApiService.fetch()).thenAnswer(
          (_) async => SuccessResult(mockTodosDto),
        );

        final result = await todoRepository.fetch();

        expect(result, isA<SuccessResult<Todos>>());
        expect((result as SuccessResult<Todos>).value.todos.length, 2);
        expect(result.value.todos[0].id, 1);
        expect(result.value.todos[1].todo, 'Todo 2');
        verify(mockTodosApiService.fetch()).called(1);
      },
    );

    test('TodosServiceがFailureResultを返した場合、FailureResultを返すこと', () async {
      final exception = Exception('API Error');
      when(mockTodosApiService.fetch()).thenAnswer(
        (_) async => FailureResult(exception),
      );

      final result = await todoRepository.fetch();

      expect(result, isA<FailureResult<Todos>>());
      expect((result as FailureResult<Todos>).error, exception);
      verify(mockTodosApiService.fetch()).called(1);
    });

    test('TodosServiceが例外をスローした場合、FailureResultを返すこと', () async {
      final exception = Exception('Network Error');
      when(mockTodosApiService.fetch()).thenThrow(exception);

      final result = await todoRepository.fetch();

      expect(result, isA<FailureResult<Todos>>());
      expect((result as FailureResult<Todos>).error, exception);
      verify(mockTodosApiService.fetch()).called(1);
    });

    test('TodoDtoの必須フィールドが欠損している場合、そのTodoはスキップされること', () async {
      final mockTodoDtos = [
        const TodoDto(userId: 1, id: 1, todo: 'Todo 1', completed: false),
        const TodoDto(id: 2, todo: 'Todo 2', completed: true), // userId欠損
        const TodoDto(userId: 3, todo: 'Todo 3', completed: false), // id欠損
        const TodoDto(userId: 4, id: 4), // その他が欠損
      ];
      final mockTodosDto = TodosDto(todos: mockTodoDtos);
      when(mockTodosApiService.fetch()).thenAnswer(
        (_) async => SuccessResult(mockTodosDto),
      );

      final result = await todoRepository.fetch();

      expect(result, isA<SuccessResult<Todos>>());
      expect((result as SuccessResult<Todos>).value.todos.length, 2);
      expect(result.value.todos[0].id, 1);
      expect(result.value.todos[1].id, 4);
      verify(mockTodosApiService.fetch()).called(1);
    });

    test('TodoDtoのフィールドがnullの場合、デフォルト値が与えられること', () async {
      final mockTodoDtos = [
        const TodoDto(userId: 4, id: 4), // userIdとid以外がnull
      ];
      final mockTodosDto = TodosDto(todos: mockTodoDtos);
      when(mockTodosApiService.fetch()).thenAnswer(
        (_) async => SuccessResult(mockTodosDto),
      );

      final result = await todoRepository.fetch();

      expect(result, isA<SuccessResult<Todos>>());
      expect((result as SuccessResult<Todos>).value.todos.length, 1);
      expect(result.value.todos[0].todo, isEmpty);
      expect(result.value.todos[0].completed, isFalse);
      verify(mockTodosApiService.fetch()).called(1);
    });
  });

  // fetchByIdメソッドのテスト
  group('fetchById', () {
    test(
      'TodosServiceがSuccessResultを返した場合、Todoエンティティに変換してSuccessResultを返すこと',
      () async {
        const mockTodoDto = TodoDto(
          userId: 1,
          id: 1,
          todo: 'Test Todo',
          completed: false,
        );
        when(mockTodosApiService.fetchById(id: 1)).thenAnswer(
          (_) async => const SuccessResult(mockTodoDto),
        );

        final result = await todoRepository.fetchById(id: 1);

        expect(result, isA<SuccessResult<Todo>>());
        expect((result as SuccessResult<Todo>).value.id, 1);
        expect(result.value.todo, 'Test Todo');
        verify(mockTodosApiService.fetchById(id: 1)).called(1);
      },
    );

    test('TodosServiceがFailureResultを返した場合、FailureResultを返すこと', () async {
      final exception = Exception('API Error');
      when(mockTodosApiService.fetchById(id: 1)).thenAnswer(
        (_) async => FailureResult(exception),
      );

      final result = await todoRepository.fetchById(id: 1);

      expect(result, isA<FailureResult<Todo>>());
      expect((result as FailureResult<Todo>).error, exception);
      verify(mockTodosApiService.fetchById(id: 1)).called(1);
    });

    test('TodosServiceが例外をスローした場合、FailureResultを返すこと', () async {
      final exception = Exception('Network Error');
      when(mockTodosApiService.fetchById(id: 1)).thenThrow(exception);

      final result = await todoRepository.fetchById(id: 1);

      expect(result, isA<FailureResult<Todo>>());
      expect((result as FailureResult<Todo>).error, exception);
      verify(mockTodosApiService.fetchById(id: 1)).called(1);
    });

    test('TodoDtoの必須フィールドが欠損している場合、fetchByIdがFailureResultを返すこと', () async {
      // userIdとidが欠損
      const mockTodoDto = TodoDto(
        todo: 'Test Todo',
        completed: false,
      );
      when(mockTodosApiService.fetchById(id: 1)).thenAnswer(
        (_) async => const SuccessResult(mockTodoDto),
      );

      final result = await todoRepository.fetchById(id: 1);

      expect(result, isA<FailureResult<Todo>>());
      final failure = result as FailureResult<Todo>;
      expect(failure.error, isA<Exception>());
      expect(
        failure.error.toString(),
        'Exception: Required fields missing for Todo with ID 1',
      );
      verify(mockTodosApiService.fetchById(id: 1)).called(1);
    });
  });
}

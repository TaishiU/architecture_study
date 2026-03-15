part of 'todo_list_screen_state.dart';

/// プロバイダ
final AsyncNotifierProvider<TodoListScreenViewModel, TodoListScreenState>
todoListScreenProvider =
    AsyncNotifierProvider.autoDispose<
      TodoListScreenViewModel,
      TodoListScreenState
    >(
      TodoListScreenViewModel.new,
    );

/// // Todoリスト画面のViewModel
class TodoListScreenViewModel extends AsyncNotifier<TodoListScreenState> {
  late final TodoRepository _todoRepository;
  late final AuthRepository _authRepository;

  @override
  Future<TodoListScreenState> build() async {
    _todoRepository = ref.read(todoRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);

    try {
      // throw Exception('意図的なエラー');
      final todos = await fetchTodos();
      return TodoListScreenState(todos: todos);
    } on Exception catch (error) {
      logger.e('[TodoListScreenViewModel] $error');
      throw Exception();
    }
  }

  /// ログイン
  Future<void> login() async {
    final result = await _authRepository.login();

    switch (result) {
      case SuccessResult<void>():
        return result.value;
      case FailureResult<void>():
        logger.e('[TodoListScreenViewModel] login failed: ${result.error}');
        throw Exception();
    }
  }

  /// [Todos] を取得
  Future<Todos> fetchTodos() async {
    final result = await _todoRepository.fetch();

    switch (result) {
      case SuccessResult<Todos>():
        return result.value;
      case FailureResult<Todos>():
        logger.e(
          '[TodoListScreenViewModel] fetchTodos failed: ${result.error}',
        );
        throw Exception();
    }
  }
}

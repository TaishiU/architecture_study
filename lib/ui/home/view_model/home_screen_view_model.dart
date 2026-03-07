part of 'home_screen_state.dart';

/// プロバイダ
final homeScreenProvider =
    AsyncNotifierProvider<HomeScreenViewModel, HomeScreenState>(
      HomeScreenViewModel.new,
    );

/// ホーム画面のViewModel
class HomeScreenViewModel extends AsyncNotifier<HomeScreenState> {
  late final TodoRepository _todoRepository;
  late final AuthRepository _authRepository;

  @override
  Future<HomeScreenState> build() async {
    _todoRepository = ref.read(todoRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);

    try {
      // throw Exception('意図的なエラー');
      final todos = await fetchTodos();
      logger.d('[HomeScreenViewModel] todos: ${todos.todos.length}');
      return HomeScreenState(todos: todos);
    } on Exception catch (error) {
      logger.e('[HomeScreenViewModel] $error');
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
        logger.e('[HomeScreenViewModel] login failed: ${result.error}');
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
        logger.e('[HomeScreenViewModel] fetchTodos failed: ${result.error}');
        throw Exception();
    }
  }
}

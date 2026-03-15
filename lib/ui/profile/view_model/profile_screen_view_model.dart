part of 'profile_screen_state.dart';

/// プロバイダ
final profileScreenProvider =
    AsyncNotifierProvider<ProfileScreenViewModel, ProfileScreenState>(
      ProfileScreenViewModel.new,
    );

/// プロフィール画面のViewModel
class ProfileScreenViewModel extends AsyncNotifier<ProfileScreenState> {
  late final TodoRepository _todoRepository;
  late final AuthRepository _authRepository;

  @override
  Future<ProfileScreenState> build() async {
    _todoRepository = ref.read(todoRepositoryProvider);
    _authRepository = ref.read(authRepositoryProvider);

    try {
      // throw Exception('意図的なエラー');
      final todos = await fetchTodos();
      logger.d('[ProfileScreenViewModel] todos: ${todos.todos.length}');
      return ProfileScreenState(todos: todos);
    } on Exception catch (error) {
      logger.e('[ProfileScreenViewModel] $error');
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
        logger.e('[ProfileScreenViewModel] login failed: ${result.error}');
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
        logger.e('[ProfileScreenViewModel] fetchTodos failed: ${result.error}');
        throw Exception();
    }
  }
}

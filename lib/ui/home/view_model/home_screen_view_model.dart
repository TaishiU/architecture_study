part of 'home_screen_state.dart';

/// プロバイダ
final homeScreenProvider =
    AsyncNotifierProvider<HomeScreenViewModel, HomeScreenState>(
      HomeScreenViewModel.new,
    );

/// ホーム画面のViewModel
class HomeScreenViewModel extends AsyncNotifier<HomeScreenState> {
  late final TodoRepository _todoRepository;

  @override
  Future<HomeScreenState> build() async {
    _todoRepository = ref.read(todoRepositoryProvider);

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

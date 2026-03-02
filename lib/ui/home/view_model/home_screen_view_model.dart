part of 'home_screen_state.dart';

/// プロバイダ
final AsyncNotifierProviderFamily<
  HomeScreenViewModel,
  HomeScreenState,
  TodoRepository
>
homeScreenProvider =
    AsyncNotifierProvider.family<
      HomeScreenViewModel,
      HomeScreenState,
      TodoRepository
    >(HomeScreenViewModel.new);

/// ViewModel
class HomeScreenViewModel extends AsyncNotifier<HomeScreenState> {
  /// コンストラクタ
  HomeScreenViewModel(
    this.todoRepository,
  );

  /// TodoRepository
  final TodoRepository todoRepository;

  @override
  Future<HomeScreenState> build() async {
    try {
      // throw Exception('意図的なエラー');
      final todos = await fetchTodos();
      logger.d('[HomeScreenViewModel] todos: ${todos.todos.length}');
      return HomeScreenState(todos: todos);
    } on Exception catch (error) {
      logger.e('[HomeScreenViewModel] $error');
      throw UnimplementedError();
    }
  }

  /// [Todos] を取得
  Future<Todos> fetchTodos() async {
    final result = await todoRepository.fetch();

    switch (result) {
      case SuccessResult<Todos>():
        return result.value;
      case FailureResult<Todos>():
        logger.e('[HomeScreenViewModel] ${result.error}');
        throw UnimplementedError();
    }
  }
}

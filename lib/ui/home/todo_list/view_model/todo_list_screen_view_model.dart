import 'dart:async';

import 'package:architecture_study/data/repositories/todo/todo_repository.dart';
import 'package:architecture_study/ui/home/todo_list/view_model/todo_list_screen_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final AsyncNotifierProvider<TodoListScreenViewModel, TodoListScreenState>
todoListScreenProvider =
    AsyncNotifierProvider.autoDispose<
      TodoListScreenViewModel,
      TodoListScreenState
    >(
      TodoListScreenViewModel.new,
    );

/// Todoリスト画面のViewModel
class TodoListScreenViewModel extends AsyncNotifier<TodoListScreenState> {
  @override
  FutureOr<TodoListScreenState> build() async {
    // 1. Repository層へのデータ取得依頼 (SSOTを更新)
    //    内部で _isFetched フラグによって、不必要な通信（「完了」更新等による再実行）はガードされる
    unawaited(ref.read(todoRepositoryProvider).fetch());

    // 2. SSOTである StreamProvider を watch する
    final todos = await ref.watch(todosStreamProvider.future);

    // 3. 状態を構築
    //    invalidateSelf() 後の再構築では、previousStateはnullになるため、UIの状態もリセットされる
    final previousState = state.value;

    return TodoListScreenState(
      todos: todos,
      searchQuery: previousState?.searchQuery ?? '',
    );
  }

  /// 検索クエリを更新する
  void updateSearchQuery(String query) {
    final currentState = state.value;
    if (currentState != null) {
      state = AsyncData(currentState.copyWith(searchQuery: query));
    }
  }

  /// Todoの完了状態を切り替える
  Future<void> toggleTodo(int id) async {
    // RepositoryのSSOTを更新する
    // build() 内でStreamをwatchしているため、更新されると自動的にこのViewModelも再構築される
    await ref.read(todoRepositoryProvider).toggleTodoCompletion(id: id);
  }

  /// データの再読み込みを行う
  Future<void> refresh() async {
    // 1. Repositoryに対し、SSOTを強制的に最新に更新するように依頼する
    await ref.read(todoRepositoryProvider).fetch(force: true);

    // 2. 自身のProviderを破棄して0から再構築する。
    //    これにより、build() が実行され、UI固有の状態（searchQueryなど）も初期値に戻る。
    ref.invalidateSelf();
  }
}

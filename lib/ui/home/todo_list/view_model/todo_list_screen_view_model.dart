import 'dart:async';

import 'package:architecture_study/data/repositories/todo/todo_repository.dart';
import 'package:architecture_study/domain/use_cases/auth/auth_use_case.dart';
import 'package:architecture_study/ui/home/todo_list/view_model/todo_list_screen_state.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final AsyncNotifierProvider<
  TodoListScreenViewModel,
  Result<TodoListScreenState>
>
todoListScreenProvider =
    AsyncNotifierProvider.autoDispose<
      TodoListScreenViewModel,
      Result<TodoListScreenState>
    >(
      TodoListScreenViewModel.new,
    );

/// Todoリスト画面のViewModel
class TodoListScreenViewModel
    extends AsyncNotifier<Result<TodoListScreenState>> {
  @override
  FutureOr<Result<TodoListScreenState>> build() async {
    // 1. SSOT (StreamProvider) を watch する。
    //    これにより、データの変更（完了状態のトグルなど）があった際に build が自動的に再実行される。
    final todosAsync = ref.watch(todosStreamProvider);

    // 2. Repository層へのデータ取得依頼 (SSOTを更新)
    //    fetch自体が成功したかどうかを Result 型で判定する。
    final fetchResult = await ref.read(todoRepositoryProvider).fetch();

    return switch (fetchResult) {
      SuccessResult() => () {
        // 3. データ取得に成功した場合、現在の最新値を構築して返す
        final todos =
            todosAsync.value ?? ref.read(todoRepositoryProvider).latestTodos;

        final previousResult = state.value;
        var searchQuery = '';
        if (previousResult is SuccessResult<TodoListScreenState>) {
          searchQuery = previousResult.value.searchQuery;
        }

        return SuccessResult(
          TodoListScreenState(todos: todos, searchQuery: searchQuery),
        );
      }(),
      FailureResult(:final error) => () {
        logger.e('[TodoListScreenViewModel] Error caught: $error');
        return FailureResult<TodoListScreenState>(error);
      }(),
    };
  }

  /// 検索クエリを更新する
  void updateSearchQuery(String query) {
    final currentResult = state.value;
    if (currentResult is SuccessResult<TodoListScreenState>) {
      state = AsyncData(
        SuccessResult(currentResult.value.copyWith(searchQuery: query)),
      );
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

  /// ログアウトを実行する
  Future<void> logout() async {
    final authUseCase = ref.read(authUseCaseProvider);
    await authUseCase.logout();
  }
}

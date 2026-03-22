import 'dart:async';
import 'dart:math';

import 'package:architecture_study/data/repositories/todo/todo_repository.dart';
import 'package:architecture_study/ui/home/todo_detail/view_model/todo_detail_screen_state.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

/// プロバイダ（ .family で todoId を受け取る）
final AsyncNotifierProviderFamily<
  TodoDetailScreenViewModel,
  Result<TodoDetailScreenState>,
  int
>
todoDetailScreenProvider = AsyncNotifierProvider.autoDispose
    .family<TodoDetailScreenViewModel, Result<TodoDetailScreenState>, int>(
      TodoDetailScreenViewModel.new,
    );

/// Todo詳細画面のViewModel
class TodoDetailScreenViewModel
    extends AsyncNotifier<Result<TodoDetailScreenState>> {
  /// コンストラクタ (Riverpod 3.0 では、名前付き引数ではなく位置引数として受け取る)
  TodoDetailScreenViewModel(this.todoId);

  /// プロバイダの .family 引数となる todoId
  final int todoId;

  @override
  FutureOr<Result<TodoDetailScreenState>> build() async {
    // 1. SSOT (StreamProvider) を watch する
    final todosAsync = ref.watch(todosStreamProvider);

    // 2. 該当する Todo を抽出する
    final todo = todosAsync.value?.where((t) => t.id == todoId).firstOrNull;

    if (todo != null) {
      return SuccessResult(TodoDetailScreenState(todo: todo));
    }

    // 3. まだデータがない（または取得中）の場合は fetch を試みる
    final fetchResult = await ref.read(todoRepositoryProvider).fetch();

    return switch (fetchResult) {
      SuccessResult() => () {
        // fetch後に再度抽出を試みる
        final latestTodo = ref
            .read(todoRepositoryProvider)
            .latestTodos
            .where((t) => t.id == todoId)
            .firstOrNull;

        if (latestTodo == null) {
          return FailureResult<TodoDetailScreenState>(
            Exception('Todo not found'),
          );
        }

        return SuccessResult(TodoDetailScreenState(todo: latestTodo));
      }(),
      FailureResult(:final error) => () {
        logger.e('[TodoDetailScreenViewModel] Error caught: $error');
        return FailureResult<TodoDetailScreenState>(error);
      }(),
    };
  }

  /// Todoの完了状態を切り替える (一覧画面と同様にRepositoryを更新する)
  Future<void> toggleTodo() async {
    await ref.read(todoRepositoryProvider).toggleTodoCompletion(id: todoId);
  }

  /// データの再読み込みを行う
  Future<void> refresh() async {
    await ref.read(todoRepositoryProvider).fetch(force: true);
    ref.invalidateSelf();
  }
}

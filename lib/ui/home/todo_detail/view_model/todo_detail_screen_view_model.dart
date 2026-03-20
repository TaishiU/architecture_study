import 'dart:async';

import 'package:architecture_study/data/repositories/todo/todo_repository.dart';
import 'package:architecture_study/ui/home/todo_detail/view_model/todo_detail_screen_state.dart';
import 'package:riverpod/src/providers/async_notifier.dart';

/// プロバイダ（ .family で todoId を受け取る）
final AsyncNotifierProviderFamily<
  TodoDetailScreenViewModel,
  TodoDetailScreenState,
  int
>
todoDetailScreenProvider = AsyncNotifierProvider.autoDispose
    .family<TodoDetailScreenViewModel, TodoDetailScreenState, int>(
      TodoDetailScreenViewModel.new,
    );

/// Todo詳細画面のViewModel
class TodoDetailScreenViewModel extends AsyncNotifier<TodoDetailScreenState> {
  /// コンストラクタ (Riverpod 3.0 では、名前付き引数ではなく位置引数として受け取る)
  TodoDetailScreenViewModel(this.todoId);

  /// プロバイダの .family 引数となる todoId
  final int todoId;

  @override
  FutureOr<TodoDetailScreenState> build() async {
    // SSOTである todosStreamProvider を watch する
    // selectAsync を使い、該当する Todo だけを抽出して監視する
    final todo = await ref.watch(
      todosStreamProvider.selectAsync(
        (todos) => todos.firstWhere(
          (t) => t.id == todoId,
          orElse: () => throw Exception('Todo not found'),
        ),
      ),
    );

    return TodoDetailScreenState(todo: todo);
  }

  /// Todoの完了状態を切り替える (一覧画面と同様にRepositoryを更新する)
  Future<void> toggleTodo() async {
    await ref.read(todoRepositoryProvider).toggleTodoCompletion(id: todoId);
  }
}

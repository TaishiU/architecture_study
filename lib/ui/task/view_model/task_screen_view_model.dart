part of 'task_screen_state.dart';

/// プロバイダ
final AsyncNotifierProvider<TaskScreenViewModel, Result<TaskScreenState>>
taskScreenProvider =
    AsyncNotifierProvider.autoDispose<
      TaskScreenViewModel,
      Result<TaskScreenState>
    >(
      TaskScreenViewModel.new,
    );

/// タスク画面のViewModel
class TaskScreenViewModel extends AsyncNotifier<Result<TaskScreenState>> {
  @override
  Future<Result<TaskScreenState>> build() async {
    final tasksAsync = ref.watch(tasksStreamProvider);
    return SuccessResult(TaskScreenState(tasks: tasksAsync.value ?? []));
  }

  /// タスクを追加する
  Future<void> addTask(String title) =>
      ref.read(taskRepositoryProvider).addTask(title: title);

  /// 完了状態を更新する
  Future<void> updateCompletion(int id, {required bool completed}) => ref
      .read(taskRepositoryProvider)
      .updateCompletion(
        id: id,
        completed: completed,
      );

  /// データの再読み込みを行う
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

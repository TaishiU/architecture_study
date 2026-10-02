import 'package:architecture_study/domain/entities/task/task.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'state.freezed.dart';

/// タスク画面の状態
@freezed
abstract class TaskScreenState with _$TaskScreenState {
  /// コンストラクタ
  const factory TaskScreenState({
    /// タスク一覧
    required List<Task> tasks,
  }) = _TaskScreenState;
}

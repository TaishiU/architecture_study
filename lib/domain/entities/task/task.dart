import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';

@freezed
/// タスクエンティティ
abstract class Task with _$Task {
  /// コンストラクタ
  const factory Task({
    required int id,
    required int userId,
    required String title,
    required bool completed,
  }) = _Task;
}

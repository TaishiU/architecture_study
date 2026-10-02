import 'dart:async';

import 'package:architecture_study/data/repositories/task/task_repository.dart';
import 'package:architecture_study/domain/entities/task/task.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'task_screen_state.freezed.dart';
part 'task_screen_view_model.dart';

/// タスク画面の状態
@freezed
abstract class TaskScreenState with _$TaskScreenState {
  /// コンストラクタ
  const factory TaskScreenState({
    /// タスク一覧
    required List<Task> tasks,
  }) = _TaskScreenState;
}

import 'dart:async';

import 'package:architecture_study/data/repositories/auth/auth_repository.dart';
import 'package:architecture_study/data/repositories/todos/todo_repository.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'profile_screen_state.freezed.dart';
part 'profile_screen_view_model.dart';

/// 画面の状態
@freezed
abstract class ProfileScreenState with _$ProfileScreenState {
  /// コンストラクタ
  const factory ProfileScreenState({
    /// 表示するTodoアイテムのリスト
    required Todos todos,
  }) = _ProfileScreenState;
}

import 'dart:async';

import 'package:architecture_study/data/repositories/auth/auth_repository.dart';
import 'package:architecture_study/data/repositories/todos/todo_repository.dart';
import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'home_screen_state.freezed.dart';
part 'home_screen_view_model.dart';

/// 画面の状態
@freezed
abstract class HomeScreenState with _$HomeScreenState {
  /// コンストラクタ
  const factory HomeScreenState({
    /// 表示するTodoアイテムのリスト
    required Todos todos,
  }) = _HomeScreenState;
}

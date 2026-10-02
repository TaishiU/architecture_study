import 'dart:async';

import 'package:architecture_study/domain/use_cases/auth/auth_use_case.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'login_screen_state.freezed.dart';
part 'login_screen_view_model.dart';

/// 画面の状態
@freezed
abstract class LoginScreenState with _$LoginScreenState {
  /// コンストラクタ
  const factory LoginScreenState({
    /// 表示するTodoアイテムのリスト
    required bool isLoggedIn,
  }) = _LoginScreenState;
}

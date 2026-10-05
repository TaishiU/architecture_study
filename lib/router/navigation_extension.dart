import 'package:architecture_study/presentation/home/todo_list/screen.dart';
import 'package:architecture_study/presentation/login/screen.dart';
import 'package:architecture_study/presentation/profile/screen.dart';
import 'package:architecture_study/presentation/task/screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 画面遷移ヘルパー。
extension NavigationExtension on BuildContext {
  /// ログイン画面へ遷移する。
  void toLoginScreen() => go(LoginScreen.path);

  /// Todoリスト画面へ遷移する。
  void toTodoListScreen() => go(TodoListScreen.path);

  /// Todo詳細画面へ遷移する。
  void toTodoDetailScreen({required int todoId}) =>
      push('${TodoListScreen.path}/$todoId');

  /// タスク画面へ遷移する。
  void toTaskScreen() => go(TaskScreen.path);

  /// プロフィール画面へ遷移する。
  void toProfileScreen() => go(ProfileScreen.path);
}

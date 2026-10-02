import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_detail_screen_state.freezed.dart';

/// 画面の状態を表すクラス
@freezed
abstract class TodoDetailScreenState with _$TodoDetailScreenState {
  /// コンストラクタ
  const factory TodoDetailScreenState({
    /// 表示対象のTodo
    Todo? todo,
  }) = _TodoDetailScreenState;
}

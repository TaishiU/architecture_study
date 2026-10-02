import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_list_screen_state.freezed.dart';

/// 画面の状態を表すクラス
@freezed
abstract class TodoListScreenState with _$TodoListScreenState {
  /// コンストラクタ
  const factory TodoListScreenState({
    /// SSOTから提供されるTodoリスト
    required List<Todo> todos,

    /// 検索クエリ
    required String searchQuery,
  }) = _TodoListScreenState;
}

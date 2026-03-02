import 'package:freezed_annotation/freezed_annotation.dart';

part 'todos.freezed.dart';
part 'todos.g.dart';

/// Todos
@freezed
abstract class Todos with _$Todos {
  /// コンストラクタ
  const factory Todos({
    /// ID
    required List<Todo> todos,
  }) = _Todos;

  /// JSONから生成
  factory Todos.fromJson(Map<String, Object?> json) => _$TodosFromJson(json);
}

/// Todo
@freezed
abstract class Todo with _$Todo {
  /// コンストラクタ
  const factory Todo({
    /// ID
    required int id,

    /// ユーザーID
    required int userId,

    /// タイトル
    required String todo,

    /// 完了したかどうか
    required bool completed,
  }) = _Todo;

  /// JSONから生成
  factory Todo.fromJson(Map<String, Object?> json) => _$TodoFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'todos_model.freezed.dart';
part 'todos_model.g.dart';

/// TodosModel
@freezed
abstract class TodosModel with _$TodosModel {
  /// コンストラクタ
  const factory TodosModel({
    List<TodoModel>? todos,
  }) = _TodosModel;

  /// JSONから生成
  factory TodosModel.fromJson(Map<String, dynamic> json) =>
      _$TodosModelFromJson(json);
}

/// TodoModel
@freezed
abstract class TodoModel with _$TodoModel {
  /// コンストラクタ
  const factory TodoModel({
    /// ID
    int? id,

    /// ユーザーID
    int? userId,

    /// タイトル
    @JsonKey(name: 'todo') String? todo,

    /// 完了したかどうか
    bool? completed,
  }) = _TodoModel;

  /// JSONから生成
  factory TodoModel.fromJson(Map<String, dynamic> json) =>
      _$TodoModelFromJson(json);
}

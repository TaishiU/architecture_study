import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_model.freezed.dart';
part 'login_model.g.dart';

/// LoginModel
@freezed
abstract class LoginModel with _$LoginModel {
  /// コンストラクタ
  const factory LoginModel({
    /// ID
    int? id,

    /// ユーザー名
    String? username,

    /// メールアドレス
    String? email,

    /// 姓
    String? firstName,

    /// 名
    String? lastName,

    /// 性別
    String? gender,

    /// 画像
    String? image,

    /// アクセストークン
    String? accessToken,

    /// リフレッシュトークン
    String? refreshToken,
  }) = _LoginModel;

  /// JSONから生成
  factory LoginModel.fromJson(Map<String, Object?> json) =>
      _$LoginModelFromJson(json);
}

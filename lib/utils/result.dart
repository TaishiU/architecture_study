import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// 通信結果をラップする [Result] クラス
/// sealedクラスにより、呼び出し側ではswitchで結果を評価する
@freezed
sealed class Result<T> with _$Result<T> {
  /// 通信が成功した際に値を返す
  const factory Result.success(T value) = SuccessResult<T>;

  /// 通信が失敗した際にExceptionを返す
  const factory Result.failure(Exception error) = FailureResult<T>;
}

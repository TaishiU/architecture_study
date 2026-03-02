import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// API通信結果を表す [Result] クラス
@freezed
sealed class Result<T> with _$Result<T> {
  /// 通信成功
  const factory Result.success(T value) = SuccessResult<T>;

  /// 通信失敗
  const factory Result.failure(Exception error) = FailureResult<T>;
}

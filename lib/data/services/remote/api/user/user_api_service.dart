import 'package:architecture_study/data/services/remote/dto/user/user_dto.dart';
import 'package:architecture_study/utils/result.dart';

/// インターフェース
abstract class UserApiService {
  /// [UserDto] を取得
  Future<Result<UserDto>> fetch();
}

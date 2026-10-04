import 'package:architecture_study/data/services/web_api/users/dto.dart';
import 'package:architecture_study/utils/result.dart';

/// インターフェース
abstract class UsersApiService {
  /// [UserDto] を取得
  Future<Result<UserDto>> fetchById();
}

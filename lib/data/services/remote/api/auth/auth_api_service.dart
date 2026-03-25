import 'package:architecture_study/data/services/remote/dto/login/login_dto.dart';
import 'package:architecture_study/utils/result.dart';

/// インターフェース
abstract class AuthApiService {
  /// ログイン
  Future<Result<LoginDto>> login({
    required String username,
    required String password,
  });
}

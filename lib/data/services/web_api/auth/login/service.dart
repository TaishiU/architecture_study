import 'package:architecture_study/data/services/web_api/auth/login/dto.dart';
import 'package:architecture_study/utils/result.dart';

/// インターフェース
abstract class AuthApiService {
  /// ログイン
  Future<Result<LoginDto>> login({
    required String username,
    required String password,
  });
}

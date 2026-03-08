import 'package:architecture_study/data/services/remote/dto/login/login_dto.dart';
import 'package:architecture_study/utils/result.dart';

/// インターフェース
// ignore: one_member_abstracts
abstract class AuthApiService {
  /// ログイン
  Future<Result<LoginDto>> login();
}

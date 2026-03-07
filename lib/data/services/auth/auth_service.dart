import 'package:architecture_study/data/models/login/login_model.dart';
import 'package:architecture_study/data/services/result.dart';

/// インターフェース
// ignore: one_member_abstracts
abstract class AuthService {
  /// ログイン
  Future<Result<LoginModel>> login();
}

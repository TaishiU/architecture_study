import 'package:architecture_study/data/models/login/login_model.dart';
import 'package:architecture_study/data/services/api_client.dart';
import 'package:architecture_study/data/services/api_exception.dart';
import 'package:architecture_study/data/services/auth/auth_service.dart';
import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final authServiceAPIProvider = Provider<AuthServiceAPI>(
  (ref) => AuthServiceAPI(apiClient: ref.read(apiClientProvider)),
);

/// APIサービス実装クラス
class AuthServiceAPI implements AuthService {
  /// コンストラクタ
  AuthServiceAPI({required this.apiClient});

  ///　ApiClient
  final ApiClient apiClient;

  /// エンドポイント
  static const endpoint = 'auth';

  @override
  Future<Result<LoginModel>> login() async {
    try {
      final response = await apiClient.post(
        endpoint: '$endpoint/login',
        body: {
          'username': 'emilys',
          'password': 'emilyspass',
          'expiresInMins': 30,
        },
      );
      final loginModel = LoginModel.fromJson(response);
      logger.i('[AuthServiceAPI] $loginModel');
      return SuccessResult(loginModel);
    } on ApiClientException catch (error) {
      logger.e('[AuthServiceAPI] ApiClientException: $error');
      return Result.failure(error);
    } on Exception catch (error) {
      logger.e('[AuthServiceAPI] Unexpected Error: $error');
      return Result.failure(error);
    }
  }
}

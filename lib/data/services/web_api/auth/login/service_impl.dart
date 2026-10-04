import 'package:architecture_study/data/services/web_api/api_client.dart';
import 'package:architecture_study/data/services/web_api/api_exception.dart';
import 'package:architecture_study/data/services/web_api/auth/login/dto.dart';
import 'package:architecture_study/data/services/web_api/auth/login/service.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AuthApiServiceImplのプロバイダ
final authApiServiceImplProvider = Provider<AuthApiServiceImpl>(
  (ref) => AuthApiServiceImpl(apiClient: ref.read(apiClientProvider)),
);

/// APIサービス実装クラス
class AuthApiServiceImpl implements AuthApiService {
  /// コンストラクタ
  AuthApiServiceImpl({required this.apiClient});

  ///　ApiClient
  final ApiClient apiClient;

  /// エンドポイント
  static const endpoint = 'auth/login';

  @override
  Future<Result<LoginDto>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await apiClient.post(
        endpoint: endpoint,
        body: {
          'username': username,
          'password': password,
          'expiresInMins': 30,
        },
      );
      final loginDto = LoginDto.fromJson(response);
      return SuccessResult(loginDto);
    } on ApiClientException catch (error) {
      logger.e('[AuthApiServiceImpl] ApiClientException: $error');
      return FailureResult(error);
    } on Exception catch (error) {
      logger.e('[AuthApiServiceImpl] Unexpected Error: $error');
      return FailureResult(error);
    }
  }
}

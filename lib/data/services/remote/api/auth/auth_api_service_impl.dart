import 'package:architecture_study/data/services/remote/api/api_client.dart';
import 'package:architecture_study/data/services/remote/api/api_exception.dart';
import 'package:architecture_study/data/services/remote/api/auth/auth_api_service.dart';
import 'package:architecture_study/data/services/remote/dto/login/login_dto.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
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
  static const endpoint = 'auth';

  @override
  Future<Result<LoginDto>> login() async {
    try {
      final response = await apiClient.post(
        endpoint: '$endpoint/login',
        body: {
          'username': 'emilys',
          'password': 'emilyspass',
          'expiresInMins': 30,
        },
      );
      final loginDto = LoginDto.fromJson(response);
      return SuccessResult(loginDto);
    } on ApiClientException catch (error) {
      logger.e('[AuthApiServiceImpl] ApiClientException: $error');
      return Result.failure(error);
    } on Exception catch (error) {
      logger.e('[AuthApiServiceImpl] Unexpected Error: $error');
      return Result.failure(error);
    }
  }
}

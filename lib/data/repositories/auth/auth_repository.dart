
import 'package:architecture_study/data/services/local/preferences/auth/auth_preferences_service.dart';
import 'package:architecture_study/data/services/local/preferences/auth/auth_preferences_service_impl.dart';
import 'package:architecture_study/data/services/remote/api/auth/auth_api_service.dart';
import 'package:architecture_study/data/services/remote/api/auth/auth_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/login/login_dto.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    authApiService: ref.read(authApiServiceImplProvider),
    authPreferencesService: ref.read(authPreferencesServiceImplProvider),
  ),
);

/// リポジトリクラス
class AuthRepository {
  /// コンストラクタ
  AuthRepository({
    required this.authApiService,
    required this.authPreferencesService,
  });

  /// API通信を行うAuthサービス
  final AuthApiService authApiService;

  /// ローカルのSharedPreferencesを操作するAuthPreferencesサービス
  final AuthPreferencesService authPreferencesService;

  /// [Todos] 配列を取得
  Future<Result<void>> login() async {
    try {
      final result = await authApiService.login();

      switch (result) {
        case SuccessResult<LoginDto>():
          final value = result.value;
          logger.w(value);
          return const SuccessResult(null);
        case FailureResult<LoginDto>():
          logger.e('[AuthRepository] ${result.error}');
          return FailureResult(result.error);
      }
    } on Exception catch (error) {
      return Result.failure(error);
    }
  }
}

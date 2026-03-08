import 'package:architecture_study/data/models/login/login_model.dart';
import 'package:architecture_study/data/services/auth/auth_service.dart';
import 'package:architecture_study/data/services/auth/auth_service_api.dart';
import 'package:architecture_study/data/services/preferences/auth/auth_preferences_service.dart';
import 'package:architecture_study/data/services/preferences/auth/auth_preferences_service_impl.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    authService: ref.read(authServiceAPIProvider),
    authPreferencesService: ref.read(authPreferencesServiceImplProvider),
  ),
);

/// リポジトリクラス
class AuthRepository {
  /// コンストラクタ
  AuthRepository({
    required this.authService,
    required this.authPreferencesService,
  });

  /// API通信を行うAuthサービス
  final AuthService authService;

  /// ローカルのSharedPreferencesを操作するAuthPreferencesサービス
  final AuthPreferencesService authPreferencesService;

  /// [Todos] 配列を取得
  Future<Result<void>> login() async {
    try {
      final result = await authService.login();

      switch (result) {
        case SuccessResult<LoginModel>():
          final value = result.value;
          logger.w(value);
          return const SuccessResult(null);
        case FailureResult<LoginModel>():
          logger.e('[AuthRepository] ${result.error}');
          return FailureResult(result.error);
      }
    } on Exception catch (error) {
      return Result.failure(error);
    }
  }
}

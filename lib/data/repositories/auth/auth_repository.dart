import 'package:architecture_study/data/services/local/preferences/auth/auth_preferences_service.dart';
import 'package:architecture_study/data/services/local/preferences/auth/auth_preferences_service_impl.dart';
import 'package:architecture_study/data/services/remote/api/auth/auth_api_service.dart';
import 'package:architecture_study/data/services/remote/api/auth/auth_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/login/login_dto.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(
    authApiService: ref.read(authApiServiceImplProvider),
    authPreferencesService: ref.read(authPreferencesServiceImplProvider),
  ),
);

/// リポジトリクラス
class AuthRepository extends ChangeNotifier {
  /// コンストラクタ
  AuthRepository({
    required this.authApiService,
    required this.authPreferencesService,
  });

  /// Authに関連するAPI通信を抽象化したサービスインターフェース。
  final AuthApiService authApiService;

  /// Authに関連するデータをローカルに永続化する処理を抽象化したサービスインターフェース。
  final AuthPreferencesService authPreferencesService;

  /// ログイン済みかどうか
  bool? _isLoggedIn;

  /// アクセストークン
  String? _accessToken;

  /// ログイン済みかどうか
  Future<bool> get isLoggedIn async {
    // キャッシュがあればそのまま返す
    if (_isLoggedIn != null) {
      return _isLoggedIn!;
    }
    // キャッシュがなければローカルから取得
    await getAccessToken();
    return _isLoggedIn ?? false;
  }

  /// アクセストークンをローカルから取得
  Future<void> getAccessToken() async {
    final accessToken = authPreferencesService.getAccessToken();
    _isLoggedIn = accessToken.isNotEmpty;
    _accessToken = accessToken;
  }

  /// ログイン
  Future<Result<void>> login() async {
    try {
      final result = await authApiService.login();

      switch (result) {
        case SuccessResult<LoginDto>():
          _isLoggedIn = result.value.accessToken?.isNotEmpty;
          _accessToken = result.value.accessToken;
          // ログイン状態の変更通知
          notifyListeners();
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

import 'package:architecture_study/data/services/preferences/auth/auth_preferences_service.dart';
import 'package:architecture_study/data/services/preferences/shared_preferences_service.dart';
import 'package:architecture_study/data/services/preferences/shared_preferences_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final authPreferencesServiceImplProvider = Provider<AuthPreferencesServiceImpl>(
  (ref) => AuthPreferencesServiceImpl(
    generalPreferences: ref.read(sharedPreferencesServiceImplProvider),
  ),
);

/// [AuthPreferencesService] の実装クラスです。
/// [SharedPreferencesService] を利用して、認証情報（アクセストークン、リフレッシュトークンなど）を永続化します。
class AuthPreferencesServiceImpl implements AuthPreferencesService {
  /// コンストラクタ
  AuthPreferencesServiceImpl({required this.generalPreferences});

  /// 認証情報永続化のための汎用的なSharedPreferencesサービス
  final SharedPreferencesService generalPreferences;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  @override
  String getAccessToken() {
    return generalPreferences.getString(_accessTokenKey) ?? '';
  }

  @override
  Future<void> setAccessToken(String token) {
    return generalPreferences.setString(_accessTokenKey, token);
  }

  @override
  String getRefreshToken() {
    return generalPreferences.getString(_refreshTokenKey) ?? '';
  }

  @override
  Future<void> setRefreshToken(String token) {
    return generalPreferences.setString(_refreshTokenKey, token);
  }

  @override
  Future<bool> clearAuthData() async {
    await generalPreferences.remove(_accessTokenKey);
    await generalPreferences.remove(_refreshTokenKey);
    return true;
  }
}

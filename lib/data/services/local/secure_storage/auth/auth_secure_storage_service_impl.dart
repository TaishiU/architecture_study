import 'package:architecture_study/data/services/local/secure_storage/auth/auth_secure_storage_service.dart';
import 'package:architecture_study/data/services/local/secure_storage/secure_storage_service.dart';
import 'package:architecture_study/data/services/local/secure_storage/secure_storage_service_impl.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// AuthSecureStorageServiceImplのプロバイダ
final authSecureStorageServiceImplProvider = Provider<AuthSecureStorageService>(
  (ref) => AuthSecureStorageServiceImpl(
    secureStorage: ref.read(secureStorageServiceImplProvider),
  ),
);

/// [AuthSecureStorageService] の実装クラス。
/// [SecureStorageService] を利用して、認証情報をセキュアに永続化します。
class AuthSecureStorageServiceImpl implements AuthSecureStorageService {
  /// コンストラクタ
  AuthSecureStorageServiceImpl({required this.secureStorage});

  /// セキュアなデータ保存のためのサービス
  final SecureStorageService secureStorage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  String _accessToken = '';
  String _refreshToken = '';

  /// 初期化（ストレージからメモリへロード）
  @override
  Future<void> init() async {
    _accessToken = await secureStorage.read(_accessTokenKey) ?? '';
    _refreshToken = await secureStorage.read(_refreshTokenKey) ?? '';
  }

  @override
  String getAccessToken() => _accessToken;

  @override
  Future<void> setAccessToken(String token) async {
    _accessToken = token;
    await secureStorage.write(_accessTokenKey, token);
  }

  @override
  String getRefreshToken() => _refreshToken;

  @override
  Future<void> setRefreshToken(String token) async {
    _refreshToken = token;
    await secureStorage.write(_refreshTokenKey, token);
  }

  @override
  Future<bool> clearAuthData() async {
    _accessToken = '';
    _refreshToken = '';
    await secureStorage.delete(_accessTokenKey);
    await secureStorage.delete(_refreshTokenKey);
    return true;
  }
}

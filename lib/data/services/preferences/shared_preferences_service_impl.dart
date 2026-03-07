import 'package:architecture_study/data/services/preferences/shared_preferences_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// プロバイダ
final sharedPreferencesServiceImplProvider =
    Provider<SharedPreferencesServiceImpl>(
      (ref) => SharedPreferencesServiceImpl(),
    );

/// [SharedPreferencesService] の実装クラスです。
///
/// このクラスはシングルトンパターンで設計されており、
/// アプリケーション全体で`SharedPreferencesWithCache`の単一インスタンスを管理します。
class SharedPreferencesServiceImpl implements SharedPreferencesService {
  /// ファクトリコンストラクタ。常に同じインスタンスを返します。
  factory SharedPreferencesServiceImpl() {
    return _instance;
  }

  /// プライベートコンストラクタ。外部からの直接インスタンス化を防ぎます。
  SharedPreferencesServiceImpl._internal();

  /// `SharedPreferencesWithCache`のインスタンスを保持します。
  /// late final修飾子により、初回アクセス時に初期化され、その後は不変となります。
  late final SharedPreferencesWithCache _sharedPreferences;

  /// シングルトンインスタンスです。
  static final SharedPreferencesServiceImpl _instance =
      SharedPreferencesServiceImpl._internal();

  /// `SharedPreferencesWithCache`インスタンスを初期化します。
  /// アプリケーション起動時に一度だけ呼び出す必要があります。
  Future<void> init() async {
    _sharedPreferences = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // キャッシュするキーを allowList で指定することで、
        // 不要なデータをキャッシュから除外し、メモリ使用量を最適化できます。
        allowList: <String>{
          'access_token',
          'refresh_token',
        },
      ),
    );
  }

  @override
  String? getString(String key, {String? defaultValue}) {
    return _sharedPreferences.getString(key) ?? defaultValue;
  }

  @override
  Future<void> setString(String key, String value) {
    return _sharedPreferences.setString(key, value);
  }

  @override
  bool? getBool(String key, {bool? defaultValue}) {
    return _sharedPreferences.getBool(key) ?? defaultValue;
  }

  @override
  Future<void> setBool(String key, {required bool value}) {
    return _sharedPreferences.setBool(key, value);
  }

  @override
  int? getInt(String key, {int? defaultValue}) {
    return _sharedPreferences.getInt(key) ?? defaultValue;
  }

  @override
  Future<void> setInt(String key, int value) {
    return _sharedPreferences.setInt(key, value);
  }

  @override
  double? getDouble(String key, {double? defaultValue}) {
    return _sharedPreferences.getDouble(key) ?? defaultValue;
  }

  @override
  Future<void> setDouble(String key, double value) {
    return _sharedPreferences.setDouble(key, value);
  }

  @override
  List<String>? getStringList(String key, {List<String>? defaultValue}) {
    return _sharedPreferences.getStringList(key) ?? defaultValue;
  }

  @override
  Future<void> setStringList(String key, List<String> value) {
    return _sharedPreferences.setStringList(key, value);
  }

  @override
  Future<void> remove(String key) {
    return _sharedPreferences.remove(key);
  }

  @override
  Future<void> clear() {
    return _sharedPreferences.clear();
  }
}

import 'package:architecture_study/data/services/local/preferences/settings/settings_preferences_service.dart';
import 'package:architecture_study/data/services/local/preferences/shared_preferences_service.dart';

/// [SettingsPreferencesService] の実装クラス。
/// [SharedPreferencesService] を利用して、アプリケーション設定（テーマ、言語、通知など）を永続化します。
class SettingsPreferencesServiceImpl implements SettingsPreferencesService {
  /// コンストラクタ
  SettingsPreferencesServiceImpl(this._generalPreferences);

  /// 認証情報永続化のための汎用的なSharedPreferencesサービス
  final SharedPreferencesService _generalPreferences;

  static const String _appThemeKey = 'app_theme';
  static const String _languageCodeKey = 'language_code';
  static const String _agreedToTermsKey = 'agreed_to_terms';
  static const String _notificationEnabledKey = 'notification_enabled';
  static const String _lastLoginDateKey = 'last_login_date';

  @override
  String getAppTheme() {
    return _generalPreferences.getString(_appThemeKey) ?? '';
  }

  @override
  Future<void> setAppTheme(String theme) async {
    await _generalPreferences.setString(_appThemeKey, theme);
  }

  @override
  String getLanguageCode() {
    return _generalPreferences.getString(_languageCodeKey) ?? '';
  }

  @override
  Future<void> setLanguageCode(String code) async {
    await _generalPreferences.setString(_languageCodeKey, code);
  }

  @override
  bool getAgreedToTerms() {
    return _generalPreferences.getBool(_agreedToTermsKey) ?? false;
  }

  @override
  Future<void> setAgreedToTerms({required bool agreed}) async {
    await _generalPreferences.setBool(_agreedToTermsKey, value: agreed);
  }

  @override
  bool getNotificationEnabled() {
    return _generalPreferences.getBool(_notificationEnabledKey) ?? false;
  }

  @override
  Future<void> setNotificationEnabled({required bool enabled}) async {
    await _generalPreferences.setBool(_notificationEnabledKey, value: enabled);
  }

  @override
  String getLastLoginDate() {
    return _generalPreferences.getString(_lastLoginDateKey) ?? '';
  }

  @override
  Future<void> setLastLoginDate(String date) async {
    await _generalPreferences.setString(_lastLoginDateKey, date);
  }

  @override
  Future<bool> clearSettingsData() async {
    await _generalPreferences.remove(_appThemeKey);
    await _generalPreferences.remove(_agreedToTermsKey);
    await _generalPreferences.remove(_notificationEnabledKey);
    await _generalPreferences.remove(_lastLoginDateKey);
    return true;
  }
}

import 'package:architecture_study/data/services/local/preferences/settings/settings_preferences_service_impl.dart';
import 'package:architecture_study/data/services/local/preferences/shared_preferences_service.dart';
import 'package:architecture_study/data/services/local/preferences/shared_preferences_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/src/shared_preferences_async.dart';

import 'settings_preferences_service_impl_test.mocks.dart';

@GenerateMocks([
  SharedPreferencesService,
  SharedPreferencesWithCache,
])
void main() {
  late MockSharedPreferencesService mockSharedPreferencesService;
  late MockSharedPreferencesWithCache mockSharedPreferencesWithCache;
  late SettingsPreferencesServiceImpl settingsPreferencesServiceImpl;

  const appThemeKey = 'app_theme';
  const languageCodeKey = 'language_code';
  const agreedToTermsKey = 'agreed_to_terms';
  const notificationEnabledKey = 'notification_enabled';
  const lastLoginDateKey = 'last_login_date';

  setUp(() {
    mockSharedPreferencesService = MockSharedPreferencesService();
    mockSharedPreferencesWithCache = MockSharedPreferencesWithCache();
    settingsPreferencesServiceImpl = SettingsPreferencesServiceImpl(
      generalPreferences: mockSharedPreferencesService,
    );

    // 各テストケースの前にモックの呼び出し履歴をクリアします。
    reset(mockSharedPreferencesService);
    reset(mockSharedPreferencesWithCache);
  });

  group('settingsPreferencesServiceImplProvider', () {
    late ProviderContainer container;

    setUp(() {
      mockSharedPreferencesService = MockSharedPreferencesService();
      mockSharedPreferencesWithCache = MockSharedPreferencesWithCache();
      container = ProviderContainer(
        overrides: [
          // `sharedPreferencesServiceImplProvider` をオーバーライドして、
          // `SettingsPreferencesServiceImpl` がモックを使用するようにします。
          sharedPreferencesServiceImplProvider.overrideWithValue(
            SharedPreferencesServiceImpl(mockSharedPreferencesWithCache),
          ),
        ],
      );
      reset(mockSharedPreferencesService);
      reset(mockSharedPreferencesWithCache);
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'settingsPreferencesServiceImplProviderは'
      'SettingsPreferencesServiceImplのインスタンスを返すこと',
      () {
        final service = container.read(settingsPreferencesServiceImplProvider);
        expect(service, isA<SettingsPreferencesServiceImpl>());
      },
    );

    test(
      'settingsPreferencesServiceImplProviderは'
      '指定されたMockSharedPreferencesWithCacheで初期化されること',
      () {
        final service = container.read(settingsPreferencesServiceImplProvider);

        // モックされたgetStringメソッドを呼び出すことで、
        // 内部で渡されたMockSharedPreferencesWithCacheが使用されていることを確認
        when(
          mockSharedPreferencesWithCache.getString('test_key'),
        ).thenReturn('test_value');
        final value = service.generalPreferences.getString('test_key');
        expect(value, 'test_value');
        verify(
          mockSharedPreferencesWithCache.getString('test_key'),
        ).called(1);
      },
    );

    test(
      'overridesなしでsettingsPreferencesServiceImplProviderにアクセスした場合、'
      'ProviderExceptionがスローされること',
      () {
        // Providerをオーバーライドせずにコンテナを作成
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // プロバイダを読み込もうとするとProviderExceptionがスローされることを確認
        expect(
          () => container.read(settingsPreferencesServiceImplProvider),
          throwsA(isA<ProviderException>()),
        );
      },
    );
  });

  group('SettingsPreferencesServiceImpl', () {
    // getAppTheme / setAppTheme
    test('getAppThemeは_generalPreferences.getStringを正しいキーで呼び出すこと', () {
      when(
        mockSharedPreferencesService.getString(appThemeKey),
      ).thenReturn('dark');
      final result = settingsPreferencesServiceImpl.getAppTheme();
      expect(result, 'dark');
      verify(mockSharedPreferencesService.getString(appThemeKey)).called(1);
    });

    test('getAppThemeがnullを返した場合、空文字列を返すこと', () {
      when(
        mockSharedPreferencesService.getString(appThemeKey),
      ).thenReturn(null);
      final result = settingsPreferencesServiceImpl.getAppTheme();
      expect(result, '');
      verify(mockSharedPreferencesService.getString(appThemeKey)).called(1);
    });

    test('setAppThemeは_generalPreferences.setStringを正しいキーと値で呼び出すこと', () async {
      when(
        mockSharedPreferencesService.setString(appThemeKey, 'light'),
      ).thenAnswer((_) async => true);
      await settingsPreferencesServiceImpl.setAppTheme('light');
      verify(
        mockSharedPreferencesService.setString(appThemeKey, 'light'),
      ).called(1);
    });

    // getLanguageCode / setLanguageCode
    test('getLanguageCodeは_generalPreferences.getStringを正しいキーで呼び出すこと', () {
      when(
        mockSharedPreferencesService.getString(languageCodeKey),
      ).thenReturn('en');
      final result = settingsPreferencesServiceImpl.getLanguageCode();
      expect(result, 'en');
      verify(mockSharedPreferencesService.getString(languageCodeKey)).called(1);
    });

    test('getLanguageCodeがnullを返した場合、空文字列を返すこと', () {
      when(
        mockSharedPreferencesService.getString(languageCodeKey),
      ).thenReturn(null);
      final result = settingsPreferencesServiceImpl.getLanguageCode();
      expect(result, '');
      verify(mockSharedPreferencesService.getString(languageCodeKey)).called(1);
    });

    test(
      'setLanguageCodeは_generalPreferences.setStringを正しいキーと値で呼び出すこと',
      () async {
        when(
          mockSharedPreferencesService.setString(languageCodeKey, 'ja'),
        ).thenAnswer((_) async => true);
        await settingsPreferencesServiceImpl.setLanguageCode('ja');
        verify(
          mockSharedPreferencesService.setString(languageCodeKey, 'ja'),
        ).called(1);
      },
    );

    // getAgreedToTerms / setAgreedToTerms
    test('getAgreedToTermsは_generalPreferences.getBoolを正しいキーで呼び出すこと', () {
      when(
        mockSharedPreferencesService.getBool(agreedToTermsKey),
      ).thenReturn(true);
      final result = settingsPreferencesServiceImpl.getAgreedToTerms();
      expect(result, true);
      verify(mockSharedPreferencesService.getBool(agreedToTermsKey)).called(1);
    });

    test('getAgreedToTermsがnullを返した場合、falseを返すこと', () {
      when(
        mockSharedPreferencesService.getBool(agreedToTermsKey),
      ).thenReturn(null);
      final result = settingsPreferencesServiceImpl.getAgreedToTerms();
      expect(result, false);
      verify(mockSharedPreferencesService.getBool(agreedToTermsKey)).called(1);
    });

    test(
      'setAgreedToTermsは_generalPreferences.setBoolを正しいキーと値で呼び出すこと',
      () async {
        when(
          mockSharedPreferencesService.setBool(agreedToTermsKey, value: true),
        ).thenAnswer((_) async => true);
        await settingsPreferencesServiceImpl.setAgreedToTerms(agreed: true);
        verify(
          mockSharedPreferencesService.setBool(agreedToTermsKey, value: true),
        ).called(1);
      },
    );

    // getNotificationEnabled / setNotificationEnabled
    test('getNotificationEnabledは_generalPreferences.getBoolを正しいキーで呼び出すこと', () {
      when(
        mockSharedPreferencesService.getBool(notificationEnabledKey),
      ).thenReturn(true);
      final result = settingsPreferencesServiceImpl.getNotificationEnabled();
      expect(result, true);
      verify(
        mockSharedPreferencesService.getBool(notificationEnabledKey),
      ).called(1);
    });

    test('getNotificationEnabledがnullを返した場合、falseを返すこと', () {
      when(
        mockSharedPreferencesService.getBool(notificationEnabledKey),
      ).thenReturn(null);
      final result = settingsPreferencesServiceImpl.getNotificationEnabled();
      expect(result, false);
      verify(
        mockSharedPreferencesService.getBool(notificationEnabledKey),
      ).called(1);
    });

    test(
      'setNotificationEnabledは_generalPreferences.setBoolを正しいキーと値で呼び出すこと',
      () async {
        when(
          mockSharedPreferencesService.setBool(
            notificationEnabledKey,
            value: true,
          ),
        ).thenAnswer((_) async => true);
        await settingsPreferencesServiceImpl.setNotificationEnabled(
          enabled: true,
        );
        verify(
          mockSharedPreferencesService.setBool(
            notificationEnabledKey,
            value: true,
          ),
        ).called(1);
      },
    );

    // getLastLoginDate / setLastLoginDate
    test('getLastLoginDateは_generalPreferences.getStringを正しいキーで呼び出すこと', () {
      when(
        mockSharedPreferencesService.getString(lastLoginDateKey),
      ).thenReturn('2023-01-01');
      final result = settingsPreferencesServiceImpl.getLastLoginDate();
      expect(result, '2023-01-01');
      verify(
        mockSharedPreferencesService.getString(lastLoginDateKey),
      ).called(1);
    });

    test('getLastLoginDateがnullを返した場合、空文字列を返すこと', () {
      when(
        mockSharedPreferencesService.getString(lastLoginDateKey),
      ).thenReturn(null);
      final result = settingsPreferencesServiceImpl.getLastLoginDate();
      expect(result, '');
      verify(
        mockSharedPreferencesService.getString(lastLoginDateKey),
      ).called(1);
    });

    test(
      'setLastLoginDateは_generalPreferences.setStringを正しいキーと値で呼び出すこと',
      () async {
        when(
          mockSharedPreferencesService.setString(
            lastLoginDateKey,
            '2023-01-02',
          ),
        ).thenAnswer((_) async => true);
        await settingsPreferencesServiceImpl.setLastLoginDate('2023-01-02');
        verify(
          mockSharedPreferencesService.setString(
            lastLoginDateKey,
            '2023-01-02',
          ),
        ).called(1);
      },
    );

    // clearSettingsData
    test('clearSettingsDataは_generalPreferences.removeを全てのキーで呼び出すこと', () async {
      when(
        mockSharedPreferencesService.remove(appThemeKey),
      ).thenAnswer((_) async => true);
      when(
        mockSharedPreferencesService.remove(agreedToTermsKey),
      ).thenAnswer((_) async => true);
      when(
        mockSharedPreferencesService.remove(notificationEnabledKey),
      ).thenAnswer((_) async => true);
      when(
        mockSharedPreferencesService.remove(lastLoginDateKey),
      ).thenAnswer((_) async => true);

      final result = await settingsPreferencesServiceImpl.clearSettingsData();
      expect(result, isTrue);
      verify(mockSharedPreferencesService.remove(appThemeKey)).called(1);
      verify(mockSharedPreferencesService.remove(agreedToTermsKey)).called(1);
      verify(
        mockSharedPreferencesService.remove(notificationEnabledKey),
      ).called(1);
      verify(mockSharedPreferencesService.remove(lastLoginDateKey)).called(1);
    });
  });
}

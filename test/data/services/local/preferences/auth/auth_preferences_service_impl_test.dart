import 'package:architecture_study/data/services/local/preferences/auth/auth_preferences_service_impl.dart';
import 'package:architecture_study/data/services/local/preferences/shared_preferences_service.dart';
import 'package:architecture_study/data/services/local/preferences/shared_preferences_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/src/shared_preferences_async.dart';

import 'auth_preferences_service_impl_test.mocks.dart';

@GenerateMocks([
  SharedPreferencesService,
  SharedPreferencesWithCache,
])
void main() {
  late MockSharedPreferencesService mockSharedPreferencesService;
  late MockSharedPreferencesWithCache mockSharedPreferencesWithCache;
  late AuthPreferencesServiceImpl authPreferencesServiceImpl;

  const accessTokenKey = 'access_token';
  const refreshTokenKey = 'refresh_token';

  setUp(() {
    mockSharedPreferencesService = MockSharedPreferencesService();
    mockSharedPreferencesWithCache = MockSharedPreferencesWithCache();
    authPreferencesServiceImpl = AuthPreferencesServiceImpl(
      generalPreferences: mockSharedPreferencesService,
    );

    // 各テストケースの前にモックの呼び出し履歴をクリアします。
    reset(mockSharedPreferencesService);
    reset(mockSharedPreferencesWithCache);
  });

  group('authPreferencesServiceImplProvider', () {
    late ProviderContainer container;

    setUp(() {
      mockSharedPreferencesService = MockSharedPreferencesService();
      mockSharedPreferencesWithCache = MockSharedPreferencesWithCache();
      container = ProviderContainer(
        overrides: [
          // `sharedPreferencesServiceImplProvider` をオーバーライドして、
          // `AuthPreferencesServiceImpl` がモックを使用するようにします。
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
      'authPreferencesServiceImplProviderは'
      'AuthPreferencesServiceImplのインスタンスを返すこと',
      () {
        final service = container.read(authPreferencesServiceImplProvider);
        expect(service, isA<AuthPreferencesServiceImpl>());
      },
    );

    test(
      'authPreferencesServiceImplProviderは'
      '指定されたMockSharedPreferencesWithCacheで初期化されること',
      () {
        final service = container.read(authPreferencesServiceImplProvider);

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
      'overridesなしでauthPreferencesServiceImplProviderにアクセスした場合、'
      'ProviderExceptionがスローされること',
      () {
        // Providerをオーバーライドせずにコンテナを作成
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // プロバイダを読み込もうとするとProviderExceptionがスローされることを確認
        expect(
          () => container.read(authPreferencesServiceImplProvider),
          throwsA(isA<ProviderException>()),
        );
      },
    );
  });

  group('AuthPreferencesServiceImpl', () {
    test('getAccessTokenはgeneralPreferences.getStringを正しいキーで呼び出すこと', () {
      when(
        mockSharedPreferencesService.getString(accessTokenKey),
      ).thenReturn('test_access_token');
      final result = authPreferencesServiceImpl.getAccessToken();
      expect(result, 'test_access_token');
      verify(mockSharedPreferencesService.getString(accessTokenKey)).called(1);
    });

    test('getAccessTokenがnullを返した場合、空文字列を返すこと', () {
      when(
        mockSharedPreferencesService.getString(accessTokenKey),
      ).thenReturn(null);
      final result = authPreferencesServiceImpl.getAccessToken();
      expect(result, '');
      verify(mockSharedPreferencesService.getString(accessTokenKey)).called(1);
    });

    test(
      'setAccessTokenはgeneralPreferences.setStringを正しいキーと値で呼び出すこと',
      () async {
        when(
          mockSharedPreferencesService.setString(
            accessTokenKey,
            'new_access_token',
          ),
        ).thenAnswer((_) async => true);
        await authPreferencesServiceImpl.setAccessToken('new_access_token');
        verify(
          mockSharedPreferencesService.setString(
            accessTokenKey,
            'new_access_token',
          ),
        ).called(1);
      },
    );

    test('getRefreshTokenはgeneralPreferences.getStringを正しいキーで呼び出すこと', () {
      when(
        mockSharedPreferencesService.getString(refreshTokenKey),
      ).thenReturn('test_refresh_token');
      final result = authPreferencesServiceImpl.getRefreshToken();
      expect(result, 'test_refresh_token');
      verify(mockSharedPreferencesService.getString(refreshTokenKey)).called(1);
    });

    test('getRefreshTokenがnullを返した場合、空文字列を返すこと', () {
      when(
        mockSharedPreferencesService.getString(refreshTokenKey),
      ).thenReturn(null);
      final result = authPreferencesServiceImpl.getRefreshToken();
      expect(result, '');
      verify(mockSharedPreferencesService.getString(refreshTokenKey)).called(1);
    });

    test(
      'setRefreshTokenはgeneralPreferences.setStringを正しいキーと値で呼び出すこと',
      () async {
        when(
          mockSharedPreferencesService.setString(
            refreshTokenKey,
            'new_refresh_token',
          ),
        ).thenAnswer((_) async => true);
        await authPreferencesServiceImpl.setRefreshToken('new_refresh_token');
        verify(
          mockSharedPreferencesService.setString(
            refreshTokenKey,
            'new_refresh_token',
          ),
        ).called(1);
      },
    );

    test('clearAuthDataはgeneralPreferences.removeを両方のキーで呼び出すこと', () async {
      when(
        mockSharedPreferencesService.remove(accessTokenKey),
      ).thenAnswer((_) async => true);
      when(
        mockSharedPreferencesService.remove(refreshTokenKey),
      ).thenAnswer((_) async => true);
      final result = await authPreferencesServiceImpl.clearAuthData();
      expect(result, isTrue);
      verify(mockSharedPreferencesService.remove(accessTokenKey)).called(1);
      verify(mockSharedPreferencesService.remove(refreshTokenKey)).called(1);
    });
  });
}

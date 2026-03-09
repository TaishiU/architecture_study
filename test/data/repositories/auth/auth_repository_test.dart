import 'package:architecture_study/data/repositories/auth/auth_repository.dart';
import 'package:architecture_study/data/services/local/preferences/auth/auth_preferences_service.dart';
import 'package:architecture_study/data/services/local/preferences/auth/auth_preferences_service_impl.dart';
import 'package:architecture_study/data/services/remote/api/auth/auth_api_service.dart';
import 'package:architecture_study/data/services/remote/api/auth/auth_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/login/login_dto.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

// MissingDummyValueErrorを解決するためにダミー値を提供するヘルパー関数
void _setupDummyValues() {
  provideDummyBuilder<Result<LoginDto>>(
    (_, __) => const SuccessResult(LoginDto()),
  );
  provideDummyBuilder<Result<void>>(
    (_, __) => const SuccessResult(null),
  );
}

@GenerateMocks([
  AuthApiService,
  AuthApiServiceImpl,
  AuthPreferencesService,
  AuthPreferencesServiceImpl,
])
void main() {
  // main関数の先頭でダミー値をセットアップ
  _setupDummyValues();

  late MockAuthApiService mockAuthApiService;
  late MockAuthPreferencesService mockAuthPreferencesService;
  late AuthRepository authRepository;

  setUp(() {
    mockAuthApiService = MockAuthApiService();
    mockAuthPreferencesService = MockAuthPreferencesService();
    authRepository = AuthRepository(
      authApiService: mockAuthApiService,
      authPreferencesService: mockAuthPreferencesService,
    );
  });

  // authRepositoryProviderのテスト
  group('authRepositoryProvider', () {
    late ProviderContainer container;
    late MockAuthApiServiceImpl mockAuthApiServiceImpl;
    late MockAuthPreferencesServiceImpl mockAuthPreferencesServiceImpl;

    setUp(() {
      mockAuthApiServiceImpl = MockAuthApiServiceImpl();
      mockAuthPreferencesServiceImpl = MockAuthPreferencesServiceImpl();
      // Providerをモックするoverrideを設定してProviderContainerを初期化
      container = ProviderContainer(
        overrides: [
          authApiServiceImplProvider.overrideWith(
            (ref) => mockAuthApiServiceImpl,
          ),
          authPreferencesServiceImplProvider.overrideWith(
            (ref) => mockAuthPreferencesServiceImpl,
          ),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('authRepositoryProviderはAuthRepositoryのインスタンスを返すこと', () {
      final repository = container.read(authRepositoryProvider);
      expect(repository, isA<AuthRepository>());
    });

    test(
      'authRepositoryProviderは指定されたAuthApiServiceとAuthPreferencesServiceで初期化されること',
      () async {
        final repository = container.read(authRepositoryProvider);

        // モックされたloginメソッドを呼び出すことで、
        // 内部で渡されたAuthApiServiceが使用されていることを確認
        when(mockAuthApiServiceImpl.login()).thenAnswer(
          (_) async => const SuccessResult(LoginDto()),
        );
        // AuthPreferencesServiceのメソッドは今回は直接呼び出されないが、
        // 依存関係が正しく解決されていることを確認するためにモックを渡している
        // 必要に応じてwhen/verifyを追加

        await repository.login();
        verify(mockAuthApiServiceImpl.login()).called(1);
        // `AuthPreferencesService`のメソッドがリポジトリ内で使われるようになったら、
        // ここにverifyを追加すること
        // verify(mockAuthPreferencesServiceImpl.saveToken()).called(1);
      },
    );
  });

  // loginメソッドのテスト
  group('login', () {
    test(
      'AuthApiServiceがSuccessResultを返した場合、SuccessResult<void>を返すこと',
      () async {
        const mockLoginDto = LoginDto();
        when(mockAuthApiService.login()).thenAnswer(
          (_) async => const SuccessResult(mockLoginDto),
        );

        final result = await authRepository.login();

        expect(result, isA<SuccessResult<void>>());
        verify(mockAuthApiService.login()).called(1);
      },
    );

    test(
      'AuthApiServiceがFailureResultを返した場合、FailureResult<void>を返すこと',
      () async {
        final exception = Exception('API Error');
        when(mockAuthApiService.login()).thenAnswer(
          (_) async => FailureResult(exception),
        );

        final result = await authRepository.login();

        expect(result, isA<FailureResult<void>>());
        expect((result as FailureResult<void>).error, exception);
        verify(mockAuthApiService.login()).called(1);
      },
    );

    test('AuthApiServiceが例外をスローした場合、FailureResult<void>を返すこと', () async {
      final exception = Exception('Network Error');
      when(mockAuthApiService.login()).thenThrow(exception);

      final result = await authRepository.login();

      expect(result, isA<FailureResult<void>>());
      expect((result as FailureResult<void>).error, exception);
      verify(mockAuthApiService.login()).called(1);
    });
  });
}

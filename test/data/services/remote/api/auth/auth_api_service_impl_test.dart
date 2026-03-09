import 'package:architecture_study/data/services/remote/api/api_client.dart';
import 'package:architecture_study/data/services/remote/api/api_exception.dart';
import 'package:architecture_study/data/services/remote/api/auth/auth_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/login/login_dto.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_api_service_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late AuthApiServiceImpl authApiServiceImpl;

  setUp(() {
    mockApiClient = MockApiClient();
    authApiServiceImpl = AuthApiServiceImpl(apiClient: mockApiClient);
  });

  group('authApiServiceImplProvider', () {
    late ProviderContainer container;
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
      container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(mockApiClient),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('authApiServiceImplProviderはAuthApiServiceImplのインスタンスを返すこと', () {
      final service = container.read(authApiServiceImplProvider);
      expect(service, isA<AuthApiServiceImpl>());
    });

    test('authApiServiceImplProviderは指定されたApiClientで初期化されること', () async {
      final service = container.read(authApiServiceImplProvider);
      when(
        mockApiClient.post(
          endpoint: 'auth/login',
          body: anyNamed('body'),
        ),
      ).thenAnswer(
        (_) async => {
          'id': 1,
          'username': 'emilys',
          'email': 'emily.johnson@x.dummyjson.com',
          'firstName': 'Emily',
          'lastName': 'Johnson',
          'gender': 'female',
          'image': 'https://dummyjson.com/icon/emilyj/128',
          'accessToken': 'accessToken',
          'refreshToken': 'refreshToken',
        },
      );
      await service.login();
      verify(
        mockApiClient.post(
          endpoint: 'auth/login',
          body: anyNamed('body'),
        ),
      ).called(1);
    });
  });

  group('login', () {
    test('ログインに成功した場合、SuccessResult<LoginDto>を返すこと', () async {
      final mockResponse = {
        'id': 1,
        'username': 'emilys',
        'email': 'emily.johnson@x.dummyjson.com',
        'firstName': 'Emily',
        'lastName': 'Johnson',
        'gender': 'female',
        'image': 'https://dummyjson.com/icon/emilyj/128',
        'accessToken': 'accessToken',
        'refreshToken': 'refreshToken',
      };
      when(
        mockApiClient.post(
          endpoint: 'auth/login',
          body: anyNamed('body'),
        ),
      ).thenAnswer((_) async => mockResponse);

      final result = await authApiServiceImpl.login();

      expect(result, isA<SuccessResult<LoginDto>>());
      expect((result as SuccessResult<LoginDto>).value.username, 'emilys');
      expect(result.value.accessToken, 'accessToken');
    });

    test('ApiClientExceptionが発生した場合、FailureResultを返すこと', () async {
      final apiException = ApiClientException('Unauthorized', statusCode: 401);
      when(
        mockApiClient.post(
          endpoint: 'auth/login',
          body: anyNamed('body'),
        ),
      ).thenThrow(apiException);

      final result = await authApiServiceImpl.login();

      expect(result, isA<FailureResult<LoginDto>>());
      expect((result as FailureResult<LoginDto>).error, apiException);
    });

    test('その他の例外が発生した場合、FailureResultを返すこと', () async {
      final exception = Exception('Something went wrong');
      when(
        mockApiClient.post(
          endpoint: 'auth/login',
          body: anyNamed('body'),
        ),
      ).thenThrow(exception);

      final result = await authApiServiceImpl.login();

      expect(result, isA<FailureResult<LoginDto>>());
      expect((result as FailureResult<LoginDto>).error, exception);
    });
  });
}

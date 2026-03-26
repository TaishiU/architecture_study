import 'package:architecture_study/data/services/remote/api/api_client.dart';
import 'package:architecture_study/data/services/remote/api/api_exception.dart';
import 'package:architecture_study/data/services/remote/api/user/user_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/user/user_dto.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_api_service_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late UserApiServiceImpl userApiServiceImpl;

  setUp(() {
    mockApiClient = MockApiClient();
    userApiServiceImpl = UserApiServiceImpl(apiClient: mockApiClient);
  });

  group('userApiServiceImplProvider', () {
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

    test('userApiServiceImplProviderはUserApiServiceImplのインスタンスを返すこと', () {
      final service = container.read(userApiServiceImplProvider);
      expect(service, isA<UserApiServiceImpl>());
    });

    test('userApiServiceImplProviderは指定されたApiClientで初期化されること', () async {
      final service = container.read(userApiServiceImplProvider);
      when(
        mockApiClient.get(endpoint: 'users/1'),
      ).thenAnswer(
        (_) async => {
          'id': 1,
          'firstName': 'Test',
        },
      );
      await service.fetch();
      verify(
        mockApiClient.get(endpoint: 'users/1'),
      ).called(1);
    });
  });

  group('fetch', () {
    test('ユーザーの取得に成功した場合、SuccessResult<UserDto>を返すこと', () async {
      final mockResponse = {
        'id': 1,
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
      };
      when(
        mockApiClient.get(endpoint: 'users/1'),
      ).thenAnswer((_) async => mockResponse);

      final result = await userApiServiceImpl.fetch();

      expect(result, isA<SuccessResult<UserDto>>());
      final successResult = result as SuccessResult<UserDto>;
      expect(successResult.value.id, 1);
      expect(successResult.value.firstName, 'John');
      expect(successResult.value.lastName, 'Doe');
      expect(successResult.value.email, 'john@example.com');
    });

    test('ApiClientExceptionが発生した場合、FailureResultを返すこと', () async {
      final apiException = ApiClientException('Not Found', statusCode: 404);
      when(
        mockApiClient.get(endpoint: 'users/1'),
      ).thenThrow(apiException);

      final result = await userApiServiceImpl.fetch();

      expect(result, isA<FailureResult<UserDto>>());
      expect((result as FailureResult<UserDto>).error, apiException);
    });

    test('その他の例外が発生した場合、FailureResultを返すこと', () async {
      final exception = Exception('Something went wrong');
      when(
        mockApiClient.get(endpoint: 'users/1'),
      ).thenThrow(exception);

      final result = await userApiServiceImpl.fetch();

      expect(result, isA<FailureResult<UserDto>>());
      expect((result as FailureResult<UserDto>).error, exception);
    });
  });
}

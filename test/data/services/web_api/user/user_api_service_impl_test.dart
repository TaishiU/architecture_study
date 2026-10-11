import 'package:architecture_study/data/services/web_api/api_client.dart';
import 'package:architecture_study/data/services/web_api/api_exception.dart';
import 'package:architecture_study/data/services/web_api/mock_api_enabled_provider.dart';
import 'package:architecture_study/data/services/web_api/users/dto.dart';
import 'package:architecture_study/data/services/web_api/users/fake_service_impl.dart';
import 'package:architecture_study/data/services/web_api/users/service.dart';
import 'package:architecture_study/data/services/web_api/users/service_impl.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_api_service_impl_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  late MockApiClient mockApiClient;
  late UsersApiServiceImpl userApiServiceImpl;

  setUp(() {
    mockApiClient = MockApiClient();
    userApiServiceImpl = UsersApiServiceImpl(apiClient: mockApiClient);
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
      final service = container.read(usersApiServiceImplProvider);
      expect(service, isA<UsersApiServiceImpl>());
    });

    test('userApiServiceImplProviderは指定されたApiClientで初期化されること', () async {
      final service = container.read(usersApiServiceImplProvider);
      when(
        mockApiClient.get(endpoint: 'users/1'),
      ).thenAnswer(
        (_) async => {
          'id': 1,
          'firstName': 'Test',
        },
      );
      await service.fetchById();
      verify(
        mockApiClient.get(endpoint: 'users/1'),
      ).called(1);
    });
  });

  group('usersApiServiceProvider', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          apiClientProvider.overrideWithValue(MockApiClient()),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('isMock=false のとき UsersApiServiceImpl を返すこと', () {
      final service = container.read(usersApiServiceProvider);
      expect(service, isA<UsersApiServiceImpl>());
    });

    test('isMock=true のとき FakeUsersApiServiceImpl を返すこと', () {
      container.read(isMockApiEnabledProvider.notifier).enabled = true;
      final service = container.read(usersApiServiceProvider);
      expect(service, isA<FakeUsersApiServiceImpl>());
    });

    test('isMock=false → true → false と切り替えると型が変わること', () {
      expect(
        container.read(usersApiServiceProvider),
        isA<UsersApiServiceImpl>(),
      );
      container.read(isMockApiEnabledProvider.notifier).enabled = true;
      expect(
        container.read(usersApiServiceProvider),
        isA<FakeUsersApiServiceImpl>(),
      );
      container.read(isMockApiEnabledProvider.notifier).enabled = false;
      expect(
        container.read(usersApiServiceProvider),
        isA<UsersApiServiceImpl>(),
      );
    });
  });

  group('FakeUsersApiServiceImpl', () {
    late FakeUsersApiServiceImpl fakeService;

    setUp(() {
      fakeService = FakeUsersApiServiceImpl();
    });

    test('fakeUsersApiServiceImplProvider は FakeUsersApiServiceImpl を返すこと', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(
        container.read(fakeUsersApiServiceImplProvider),
        isA<FakeUsersApiServiceImpl>(),
      );
    });

    test('fetchById は SuccessResult<UserDto> を返すこと', () async {
      final result = await fakeService.fetchById();
      expect(result, isA<SuccessResult<UserDto>>());
    });

    test('fetchById は UsersApiService を実装していること', () {
      expect(fakeService, isA<UsersApiService>());
    });

    test('返却される UserDto は必須フィールドを持つこと', () async {
      final result = await fakeService.fetchById();
      final user = (result as SuccessResult<UserDto>).value;
      expect(user.id, isNotNull);
      expect(user.firstName, isNotNull);
      expect(user.lastName, isNotNull);
      expect(user.email, isNotNull);
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

      final result = await userApiServiceImpl.fetchById();

      expect(result, isA<SuccessResult<UserDto>>());
      final successResult = result as SuccessResult<UserDto>;
      expect(successResult.value.id, 1);
      expect(successResult.value.firstName, 'John');
      expect(successResult.value.lastName, 'Doe');
      expect(successResult.value.email, 'john@example.com');
    });

    test('ApiClientExceptionが発生した場合、FailureResultを返すこと', () async {
      final apiException = ApiClientException(
        message: 'Not Found',
        statusCode: 404,
      );
      when(
        mockApiClient.get(endpoint: 'users/1'),
      ).thenThrow(apiException);

      final result = await userApiServiceImpl.fetchById();

      expect(result, isA<FailureResult<UserDto>>());
      expect((result as FailureResult<UserDto>).error, apiException);
    });

    test('その他の例外が発生した場合、FailureResultを返すこと', () async {
      final exception = Exception('Something went wrong');
      when(
        mockApiClient.get(endpoint: 'users/1'),
      ).thenThrow(exception);

      final result = await userApiServiceImpl.fetchById();

      expect(result, isA<FailureResult<UserDto>>());
      expect((result as FailureResult<UserDto>).error, exception);
    });
  });
}

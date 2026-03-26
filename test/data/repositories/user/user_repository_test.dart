import 'package:architecture_study/data/repositories/user/user_repository.dart';
import 'package:architecture_study/data/services/remote/api/user/user_api_service.dart';
import 'package:architecture_study/data/services/remote/api/user/user_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/user/user_dto.dart';
import 'package:architecture_study/domain/entities/user/user.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'user_repository_test.mocks.dart';

// MissingDummyValueErrorを解決するためにダミー値を提供するヘルパー関数
void _setupDummyValues() {
  provideDummyBuilder<Result<UserDto>>(
    (_, _) => const SuccessResult(UserDto()),
  );
}

@GenerateMocks([UserApiService, UserApiServiceImpl])
void main() {
  _setupDummyValues();

  late MockUserApiService mockUserApiService;
  late UserRepository userRepository;

  setUp(() {
    mockUserApiService = MockUserApiService();
    userRepository = UserRepository(userApiService: mockUserApiService);
  });

  group('userRepositoryProvider', () {
    late ProviderContainer container;
    late MockUserApiServiceImpl mockUserApiServiceImpl;

    setUp(() {
      mockUserApiServiceImpl = MockUserApiServiceImpl();
      container = ProviderContainer(
        overrides: [
          userApiServiceImplProvider.overrideWith(
            (ref) => mockUserApiServiceImpl,
          ),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('userRepositoryProvider は UserRepository のインスタンスを返すこと', () {
      final repository = container.read(userRepositoryProvider);
      expect(repository, isA<UserRepository>());
    });
  });

  group('fetch メソッドのテスト', () {
    const mockUserDto = UserDto(
      id: 1,
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
    );

    test('API取得成功時にSuccessResult<User>を返すこと', () async {
      when(mockUserApiService.fetch()).thenAnswer(
        (_) async => const SuccessResult(mockUserDto),
      );

      final result = await userRepository.fetch();

      expect(result, isA<SuccessResult<User>>());
      final user = (result as SuccessResult<User>).value;
      expect(user.id, 1);
      expect(user.firstName, 'John');
      expect(user.lastName, 'Doe');
      expect(user.email, 'john.doe@example.com');
      verify(mockUserApiService.fetch()).called(1);
    });

    test('APIがFailureResultを返した場合、FailureResultを返すこと', () async {
      final exception = Exception('API Error');
      when(mockUserApiService.fetch()).thenAnswer(
        (_) async => FailureResult(exception),
      );

      final result = await userRepository.fetch();

      expect(result, isA<FailureResult<User>>());
      expect((result as FailureResult).error, exception);
    });

    test('例外発生時にFailureResultを返すこと', () async {
      when(mockUserApiService.fetch()).thenThrow(Exception('Network Error'));

      final result = await userRepository.fetch();

      expect(result, isA<FailureResult<User>>());
      expect(
        (result as FailureResult).error.toString(),
        contains('Network Error'),
      );
    });
  });

  group('Entity変換のバリデーション', () {
    test('必須フィールド(id)が欠損している場合はFailureResultを返すこと', () async {
      const incompleteDto = UserDto(firstName: 'No ID');
      when(mockUserApiService.fetch()).thenAnswer(
        (_) async => const SuccessResult(incompleteDto),
      );

      final result = await userRepository.fetch();

      expect(result, isA<FailureResult<User>>());
      expect(
        (result as FailureResult).error.toString(),
        contains('Required fields missing for User'),
      );
    });

    test('null可能なフィールドにはデフォルト値が入ること', () async {
      const minimalDto = UserDto(id: 1);
      when(mockUserApiService.fetch()).thenAnswer(
        (_) async => const SuccessResult(minimalDto),
      );

      final result = await userRepository.fetch();

      expect(result, isA<SuccessResult<User>>());
      final user = (result as SuccessResult<User>).value;
      expect(user.id, 1);
      expect(user.firstName, isEmpty);
      expect(user.age, 0);
      expect(user.height, 0.0);
    });
  });
}

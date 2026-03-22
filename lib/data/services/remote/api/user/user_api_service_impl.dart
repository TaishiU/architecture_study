import 'package:architecture_study/data/services/remote/api/api_client.dart';
import 'package:architecture_study/data/services/remote/api/api_exception.dart';
import 'package:architecture_study/data/services/remote/api/user/user_api_service.dart';
import 'package:architecture_study/data/services/remote/dto/user/user_dto.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final userApiServiceImplProvider = Provider<UserApiServiceImpl>(
  (ref) => UserApiServiceImpl(apiClient: ref.read(apiClientProvider)),
);

/// APIサービス実装クラス
class UserApiServiceImpl implements UserApiService {
  /// コンストラクタ
  UserApiServiceImpl({required this.apiClient});

  ///　ApiClient
  final ApiClient apiClient;

  /// エンドポイント
  static const endpoint = 'users';

  @override
  Future<Result<UserDto>> fetch() async {
    try {
      // throw NoInternetConnectionException('通信エラー');
      final response = await apiClient.get(endpoint: '$endpoint/1');
      final userDto = UserDto.fromJson(response);
      return SuccessResult(userDto);
    } on ApiClientException catch (error) {
      logger.e('[UsererviceAPI] ApiClientException: $error');
      return FailureResult(error);
    } on Exception catch (error) {
      logger.e('[UsererviceAPI] Unexpected Error: $error');
      return FailureResult(error);
    }
  }
}

import 'package:architecture_study/data/services/web_api/api_client.dart';
import 'package:architecture_study/data/services/web_api/api_exception.dart';
import 'package:architecture_study/data/services/web_api/users/dto.dart';
import 'package:architecture_study/data/services/web_api/users/service.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final usersApiServiceImplProvider = Provider<UsersApiServiceImpl>(
  (ref) => UsersApiServiceImpl(apiClient: ref.read(apiClientProvider)),
);

/// APIサービス実装クラス
class UsersApiServiceImpl implements UsersApiService {
  /// コンストラクタ
  UsersApiServiceImpl({required this.apiClient});

  ///　ApiClient
  final ApiClient apiClient;

  /// エンドポイント
  static const endpoint = 'users';

  @override
  Future<Result<UserDto>> fetchById() async {
    try {
      // throw NoInternetConnectionException('通信エラー');
      final response = await apiClient.get(endpoint: '$endpoint/1');
      final userDto = UserDto.fromJson(response);
      return SuccessResult(userDto);
    } on ApiClientException catch (error) {
      logger.e('[UsersApiServiceImpl] ApiClientException: $error');
      return FailureResult(error);
    } on Exception catch (error) {
      logger.e('[UsersApiServiceImpl] Unexpected Error: $error');
      return FailureResult(error);
    }
  }
}

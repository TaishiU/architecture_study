import 'package:architecture_study/data/services/remote/api/api_client.dart';
import 'package:architecture_study/data/services/remote/api/api_exception.dart';
import 'package:architecture_study/data/services/remote/api/todos/todos_api_service.dart';
import 'package:architecture_study/data/services/remote/dto/todos/todos_dto.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final todosApiServiceImplProvider = Provider<TodosApiServiceImpl>(
  (ref) => TodosApiServiceImpl(apiClient: ref.read(apiClientProvider)),
);

/// APIサービス実装クラス
class TodosApiServiceImpl implements TodosApiService {
  /// コンストラクタ
  TodosApiServiceImpl({required this.apiClient});

  ///　ApiClient
  final ApiClient apiClient;

  /// エンドポイント
  static const endpoint = 'todo';

  @override
  Future<Result<TodosDto>> fetch() async {
    try {
      final response = await apiClient.get(endpoint: endpoint);
      final todosDto = TodosDto.fromJson(response);
      return SuccessResult(todosDto);
    } on ApiClientException catch (error) {
      logger.e('[TodoServiceAPI] ApiClientException: $error');
      return FailureResult(error);
    } on Exception catch (error) {
      logger.e('[TodoServiceAPI] Unexpected Error: $error');
      return FailureResult(error);
    }
  }
}

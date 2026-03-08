import 'package:architecture_study/data/models/todos/todos_model.dart';
import 'package:architecture_study/data/services/api_client.dart';
import 'package:architecture_study/data/services/api_exception.dart';
import 'package:architecture_study/data/services/todos/todos_service.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final todoServiceAPIProvider = Provider<TodoServiceAPI>(
  (ref) => TodoServiceAPI(apiClient: ref.read(apiClientProvider)),
);

/// APIサービス実装クラス
class TodoServiceAPI implements TodosService {
  /// コンストラクタ
  TodoServiceAPI({required this.apiClient});

  ///　ApiClient
  final ApiClient apiClient;

  /// エンドポイント
  static const endpoint = 'todos';

  @override
  Future<Result<TodosModel>> fetch() async {
    try {
      final response = await apiClient.get(endpoint: endpoint);
      final todosModel = TodosModel.fromJson(response);
      logger.i('[TodoServiceAPI] $todosModel');
      return SuccessResult(todosModel);
    } on ApiClientException catch (error) {
      logger.e('[TodoServiceAPI] ApiClientException: $error');
      return Result.failure(error);
    } on Exception catch (error) {
      logger.e('[TodoServiceAPI] Unexpected Error: $error');
      return Result.failure(error);
    }
  }

  @override
  Future<Result<TodoModel>> fetchById({required int id}) async {
    try {
      final responseJson = await apiClient.get(endpoint: '$endpoint/$id');
      final todoModel = TodoModel.fromJson(responseJson);
      return SuccessResult(todoModel);
    } on ApiClientException catch (error) {
      logger.e('[TodoServiceAPI] ApiClientException: $error');
      return Result.failure(error);
    } on Exception catch (error) {
      logger.e('[TodoServiceAPI] Unexpected Error: $error');
      return Result.failure(error);
    }
  }
}

import 'package:architecture_study/data/services/api_client.dart';
import 'package:architecture_study/data/services/models/todos/todos_model.dart';
import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/data/services/todos/todos_service.dart';
import 'package:architecture_study/utils/logger.dart';
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
  static const endpoint = '/todos';

  @override
  Future<Result<TodosModel>> fetch() async {
    try {
      final responseBody = await apiClient.get(endpoint: endpoint);
      final json = parseJsonMap(responseBody);
      final todosModel = TodosModel.fromJson(json);
      logger.i('[TodoServiceAPI] $todosModel');
      return SuccessResult(todosModel);
    } on Exception catch (error) {
      logger.e('[TodoServiceAPI] $error');
      // throw Exception('json.decode error: $error');
      return Result.failure(error);
    }
  }

  @override
  Future<Result<TodoModel>> fetchById({required int id}) async {
    try {
      final responseBody = await apiClient.get(endpoint: '$endpoint/$id');
      final json = parseJsonMap(responseBody);
      final todoModel = TodoModel.fromJson(json);
      return SuccessResult(todoModel);
    } on Exception catch (error) {
      logger.e('[TodoServiceAPI] $error');
      return Result.failure(error);
    }
  }
}

import 'package:architecture_study/data/services/models/todos/todos_model.dart';
import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/data/services/todos/todos_service.dart';
import 'package:architecture_study/data/services/todos/todos_service_api.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(todoService: ref.read(todoServiceAPIProvider)),
);

/// リポジトリクラス
class TodoRepository {
  /// コンストラクタ
  TodoRepository({required this.todoService});

  ///　ApiClient
  final TodosService todoService;

  /// [Todos] 配列を取得
  Future<Result<Todos>> fetch() async {
    try {
      final result = await todoService.fetch();

      switch (result) {
        case SuccessResult<TodosModel>():
          final todoList = result.value.todos!
              .map(_toEntity)
              .whereType<Todo>()
              .toList();
          final todos = Todos(todos: todoList);
          return SuccessResult(todos);
        case FailureResult<TodosModel>():
          logger.e('[TodoRepository] ${result.error}');
          return FailureResult(result.error);
      }
    } on Exception catch (error) {
      return Result.failure(error);
    }
  }

  /// IDを指定して [Todo] を取得
  Future<Result<Todo>> fetchById({required int id}) async {
    try {
      final result = await todoService.fetchById(id: id);

      switch (result) {
        case SuccessResult<TodoModel>():
          final todo = _toEntity(result.value);
          if (todo == null) {
            // _toEntityがnullを返した場合、エラーとして扱う
            return FailureResult(
              Exception('Required fields missing for Todo with ID $id'),
            );
          }
          return SuccessResult(todo);
        case FailureResult<TodoModel>():
          logger.e('[TodoRepository] ${result.error}');
          return FailureResult(result.error);
      }
    } on Exception catch (error) {
      logger.e('[TodoRepository] $error');
      return Result.failure(error);
    }
  }

  Todo? _toEntity(TodoModel model) {
    // 必須フィールドが欠損している場合はスキップ
    if (model.userId == null || model.id == null) {
      return null;
    }

    return Todo(
      userId: model.userId!,
      id: model.id!,
      todo: model.todo ?? '',
      completed: model.completed ?? false,
    );
  }
}

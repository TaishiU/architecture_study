import 'package:architecture_study/data/repositories/todos/todos_repository.dart';
import 'package:architecture_study/data/services/models/todos/todos_model.dart';
import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/data/services/todos/todos_service.dart';
import 'package:architecture_study/data/services/todos/todos_service_local.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final todoRepositoryLocalProvider = Provider<TodoRepositoryLocal>(
  (ref) =>
      TodoRepositoryLocal(todoService: ref.read(todosServiceLocalProvider)),
);

/// ローカルリポジトリ実装クラス
class TodoRepositoryLocal implements TodoRepository {
  /// コンストラクタ
  TodoRepositoryLocal({required this.todoService});

  ///　LocalClient
  final TodosService todoService;

  @override
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
          logger.e('[TodoRepositoryAPI] ${result.error}');
          return FailureResult(result.error);
      }
    } on Exception catch (error) {
      return Result.failure(error);
    }
  }

  @override
  Future<Result<Todo>> fetchById({required int id}) async {
    try {
      final result = await todoService.fetchById(id: id);

      switch (result) {
        case SuccessResult<TodoModel>():
          final todo = _toEntity(result.value);
          return SuccessResult(todo!);
        case FailureResult<TodoModel>():
          return FailureResult(result.error);
      }
    } on Exception catch (error) {
      return Result.failure(error);
    }
  }

  Todo? _toEntity(TodoModel model) {
    // 必須フィールドが欠損している場合はスキップ
    if (model.userId == null || model.id == null) return null;

    return Todo(
      userId: model.userId!,
      id: model.id!,
      todo: model.todo!,
      completed: model.completed!,
    );
  }
}

import 'package:architecture_study/data/services/remote/api/todos/todos_api_service.dart';
import 'package:architecture_study/data/services/remote/api/todos/todos_api_service_impl.dart';
import 'package:architecture_study/data/services/remote/dto/todos/todos_dto.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final todoRepositoryProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(
    todoApiService: ref.read(todosApiServiceImplProvider),
  ),
);

/// リポジトリクラス
class TodoRepository {
  /// コンストラクタ
  TodoRepository({required this.todoApiService});

  /// Todosに関連するAPI通信を抽象化したサービスインターフェース。
  final TodosApiService todoApiService;

  /// [Todos] 配列を取得
  Future<Result<Todos>> fetch() async {
    try {
      final result = await todoApiService.fetch();

      switch (result) {
        case SuccessResult<TodosDto>():
          final todoList = result.value.todos!
              .map(_toEntity)
              .whereType<Todo>()
              .toList();
          final todos = Todos(todos: todoList);
          return SuccessResult(todos);
        case FailureResult<TodosDto>():
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
      final result = await todoApiService.fetchById(id: id);

      switch (result) {
        case SuccessResult<TodoDto>():
          final todo = _toEntity(result.value);
          if (todo == null) {
            // _toEntityがnullを返した場合、エラーとして扱う
            return FailureResult(
              Exception('Required fields missing for Todo with ID $id'),
            );
          }
          return SuccessResult(todo);
        case FailureResult<TodoDto>():
          logger.e('[TodoRepository] ${result.error}');
          return FailureResult(result.error);
      }
    } on Exception catch (error) {
      logger.e('[TodoRepository] $error');
      return Result.failure(error);
    }
  }

  /// 加算
  int add({
    required int a,
    required int b,
  }) {
    // a + b
    return a + b;
  }

  /// [TodoDto] を [Todo] エンティティに変換します。
  Todo? _toEntity(TodoDto dto) {
    // 必須フィールドが欠損している場合はnullを返す
    if (dto.userId == null || dto.id == null) {
      return null;
    }

    return Todo(
      userId: dto.userId!,
      id: dto.id!,
      todo: dto.todo ?? '',
      completed: dto.completed ?? false,
    );
  }
}

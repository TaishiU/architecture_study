import 'package:architecture_study/data/models/todos/todos_model.dart';
import 'package:architecture_study/data/services/todos/todos_service.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final todosServiceLocalProvider = Provider<TodoServiceLocal>(
  (ref) => TodoServiceLocal(),
);

/// ローカルサービス実装クラス
class TodoServiceLocal implements TodosService {
  /// コンストラクタ
  TodoServiceLocal();

  @override
  Future<Result<TodosModel>> fetch() async {
    final todoModels = List.generate(10, (index) {
      return TodoModel(
        id: index + 1,
        userId: index + 1,
        todo: 'todos${index + 1}',
        completed: false,
      );
    });

    final todosModel = TodosModel(todos: todoModels);
    return SuccessResult(todosModel);
  }

  @override
  Future<Result<TodoModel>> fetchById({required int id}) async {
    const todoModel = TodoModel(
      userId: 1,
      id: 1,
      todo: 'todo1',
      completed: false,
    );
    return const SuccessResult(todoModel);
  }
}

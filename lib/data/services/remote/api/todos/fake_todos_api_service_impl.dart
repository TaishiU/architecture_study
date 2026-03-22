import 'package:architecture_study/data/services/remote/api/todos/todos_api_service.dart';
import 'package:architecture_study/data/services/remote/dto/todos/todos_dto.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final fakeTodoApiServiceImplProvider = Provider<FakeTodoApiServiceImpl>(
  (ref) => FakeTodoApiServiceImpl(),
);

/// 開発用サービス実装クラス
class FakeTodoApiServiceImpl implements TodosApiService {
  /// コンストラクタ
  FakeTodoApiServiceImpl();

  @override
  Future<Result<TodosDto>> fetch() async {
    final todos = List.generate(10, (index) {
      return TodoDto(
        id: index + 1,
        userId: index + 1,
        todo: 'todo${index + 1}',
        completed: false,
      );
    });

    final todosDto = TodosDto(todos: todos);
    return SuccessResult(todosDto);
  }
}

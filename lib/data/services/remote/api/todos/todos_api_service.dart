import 'package:architecture_study/data/services/remote/dto/todos/todos_dto.dart';
import 'package:architecture_study/utils/result.dart';

/// インターフェース
abstract class TodosApiService {
  /// [TodosDto] を取得
  Future<Result<TodosDto>> fetch();
}

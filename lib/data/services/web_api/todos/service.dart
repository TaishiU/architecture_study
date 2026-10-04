import 'package:architecture_study/data/services/web_api/todos/dto.dart';
import 'package:architecture_study/utils/result.dart';

/// インターフェース
abstract class TodosApiService {
  /// [TodosDto] を取得
  Future<Result<TodosDto>> fetch();
}

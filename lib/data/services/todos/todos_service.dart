import 'package:architecture_study/data/models/todos/todos_model.dart';
import 'package:architecture_study/data/services/result.dart';

/// インターフェース
abstract class TodosService {
  /// [TodosModel] を取得
  Future<Result<TodosModel>> fetch();

  /// IDを指定して [TodoModel] を取得
  Future<Result<TodoModel>> fetchById({required int id});
}

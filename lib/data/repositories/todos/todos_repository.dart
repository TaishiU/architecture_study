import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';

/// インターフェース
abstract class TodoRepository {
  /// [Todos] 配列を取得
  Future<Result<Todos>> fetch();

  /// IDを指定して [Todo] を取得
  Future<Result<Todo>> fetchById({required int id});
}

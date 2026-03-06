import 'package:architecture_study/data/repositories/todos/todo_repository_api.dart';
import 'package:architecture_study/data/services/result.dart';
import 'package:architecture_study/domain/entities/todos/todos.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// TodoRepositoryの抽象プロバイダ
final todoRepositoryProvider = Provider<TodoRepository>(
  // API版をデフォルトとして提供
  (ref) => ref.read(todoRepositoryAPIProvider),
);

/// インターフェース
abstract class TodoRepository {
  /// [Todos] 配列を取得
  Future<Result<Todos>> fetch();

  /// IDを指定して [Todo] を取得
  Future<Result<Todo>> fetchById({required int id});
}

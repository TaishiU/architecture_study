import 'package:architecture_study/data/services/local/database/app_database.dart';
import 'package:architecture_study/data/services/local/database/task/task_local_service.dart';
import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// [TaskLocalService] のプロバイダ。
final taskLocalServiceImplProvider = Provider<TaskLocalServiceImpl>(
  (ref) => TaskLocalServiceImpl(ref.read(appDatabaseProvider)),
);

/// [TaskLocalService] のDrift実装クラス。
class TaskLocalServiceImpl implements TaskLocalService {
  /// コンストラクタ。
  TaskLocalServiceImpl(this._db);

  final AppDatabase _db;

  @override
  Stream<List<TodoItem>> watchAll() => _db.select(_db.todoItems).watch();

  @override
  Future<List<TodoItem>> fetchAll() => _db.select(_db.todoItems).get();

  @override
  Future<void> upsertAll(List<TodoItem> items) async {
    await _db.batch(
      (batch) => batch.insertAllOnConflictUpdate(_db.todoItems, items),
    );
  }

  @override
  Future<void> updateCompletion({
    required int id,
    required bool completed,
  }) async {
    await (_db.update(_db.todoItems)..where((t) => t.id.equals(id))).write(
      TodoItemsCompanion(completed: Value(completed)),
    );
  }

  @override
  Future<void> deleteAll() => _db.delete(_db.todoItems).go();
}

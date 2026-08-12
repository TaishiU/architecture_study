import 'package:architecture_study/data/services/local/database/app_database.dart';

/// ローカルDBのタスク操作を抽象化するインターフェース。
abstract class TaskLocalService {
  /// 全タスクをリアルタイムで監視するStreamを返す。
  Stream<List<TodoItem>> watchAll();

  /// 全タスクを一括取得する。
  Future<List<TodoItem>> fetchAll();

  /// 全タスクをupsert（挿入 or 更新）する。
  Future<void> upsertAll(List<TodoItem> items);

  /// 指定IDのタスクの完了状態を更新する。
  Future<void> updateCompletion({required int id, required bool completed});

  /// 全タスクを削除する。
  Future<void> deleteAll();
}

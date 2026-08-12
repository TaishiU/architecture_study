import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// [AppDatabase] のプロバイダ。スコープ終了時にDBを閉じる。
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

/// Todoアイテムを永続化するDriftテーブル定義。
class TodoItems extends Table {
  /// サーバーサイドのID（主キー）。
  IntColumn get id => integer()();

  /// ユーザーID。
  IntColumn get userId => integer()();

  /// Todoのテキスト。
  TextColumn get todo => text()();

  /// 完了フラグ。
  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// アプリ全体で使用するDriftデータベース。
@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  /// コンストラクタ。[executor] を省略するとデフォルト接続を使用する。
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}

# Task画面 繋ぎ込み実装メモ

## 現状の構造

```
AppDatabase
  └─ TodoItems テーブル → Drift生成データクラス: TodoItem
       ※ todo機能のリモートAPIとは別物だが、名前が衝突している

TaskLocalService (Drift)
  └─ watchAll(): Stream<List<TodoItem>>   ← TodoItem を使用中（要リネーム）
  └─ fetchAll(), upsertAll(), updateCompletion(), deleteAll()
  ※ 単一アイテム insert メソッドは未定義

TaskScreenViewModel  ← Repository が不在で繋がっていない
TaskScreen           ← 骨格のみ
```

### リネーム方針

| 変更前 | 変更後 | 対象 |
|--------|--------|------|
| `TodoItems`（Driftテーブルクラス） | `TaskItems` | `AppDatabase` |
| `TodoItem`（Drift生成データクラス） | `TaskItem` | `AppDatabase`, `TaskLocalService`, `TaskLocalServiceImpl` |
| `_db.todoItems` | `_db.taskItems` | `TaskLocalServiceImpl` |
| `Todo`（Repository・State・View で参照するエンティティ） | `Task`（新規作成） | `domain/entities/task/`, `TaskRepository`, `TaskScreenState`, `TaskScreen` |

> `TodoRepository` はリモートAPIのみを使用しローカルDBに触れないため、リネームの影響を受けない。

---

## 追加・変更するファイル

### 1. `lib/data/services/local/database/app_database.dart` （変更）

```
TodoItems → TaskItems にリネーム
id カラムを integer().autoIncrement()() に変更
  → DB が 1, 2, 3... を自動採番
  → autoIncrement() は主キーを暗黙的に設定するため primaryKey override も不要
@DriftDatabase(tables: [TaskItems])
→ Drift が TaskItem データクラスを自動生成
→ build_runner 再実行が必要
```

### 2. `lib/domain/entities/task/task.dart` （新規作成）

```
@freezed
Task
  ├─ id: int
  ├─ userId: int
  ├─ title: String
  └─ completed: bool
→ build_runner 再実行が必要
```

### 3. `lib/data/services/local/database/task/task_local_service.dart` （変更）

```
TodoItem → TaskItem にリネーム
insert({required String title}) を追加

TaskLocalService（abstract）
  ├─ watchAll(): Stream<List<TaskItem>>
  ├─ fetchAll(): Future<List<TaskItem>>
  ├─ insert({required String title})   ← 追加
  ├─ upsertAll(List<TaskItem> items)
  ├─ updateCompletion({required int id, required bool completed})
  └─ deleteAll()
```

### 4. `lib/data/services/local/database/task/task_local_service_impl.dart` （変更）

```
TodoItem → TaskItem にリネーム
_db.todoItems → _db.taskItems に置換

insert({required String title}) を実装:
  _db.into(_db.taskItems).insert(
    TaskItemsCompanion.insert(
      // id は autoIncrement のため省略（DB が 1, 2, 3... を自動採番）
      userId: 0,
      todo: title,
      completed: const Value(false),
    ),
  )
```

### 5. `lib/data/repositories/task/task_repository.dart` （新規作成）

`TaskLocalService` の `watchAll()` は Drift が常時 DB を監視するストリームを返す。`StreamController` を自前で持つ必要はなく、`.map()` で `TaskItem → Task` 変換して公開するだけでよい。

```
taskRepositoryProvider  ← TaskLocalServiceImpl を注入
tasksStreamProvider     ← TaskRepository.tasksStream を StreamProvider に登録

TaskRepository
  ├─ tasksStream: Stream<List<Task>>
  │    └─ taskLocalService.watchAll().map(_toEntity)
  ├─ addTask({required String title})
  │    └─ taskLocalService.insert(title: title)
  └─ updateCompletion({required int id, required bool completed})
       └─ taskLocalService.updateCompletion(...)
```

> `fetchAll()` は今回のローカル専用では不要。Drift ストリームが常に最新を流すため、「取得して SSOT を更新」の手順が不要。

### 6. `lib/ui/task/view_model/task_screen_state.dart` （変更）

```
TaskScreenState
  └─ tasks: List<Task>   ← 追加（Task エンティティ）
→ build_runner 再実行が必要
```

### 7. `lib/ui/task/view_model/task_screen_view_model.dart` （変更）

```
build() async:
  ref.watch(tasksStreamProvider)      ← DB変更時に build 自動再実行
  → SuccessResult(TaskScreenState(tasks: tasksAsync.value ?? []))

addTask(String title):
  ref.read(taskRepositoryProvider).addTask(title: title)
  // → DB insert → watchAll() 発火 → build() 自動再実行

updateCompletion(int id, bool completed):
  ref.read(taskRepositoryProvider).updateCompletion(id: id, completed: completed)
  // → DB更新 → watchAll() 発火 → build() 自動再実行
```

### 8. `lib/ui/task/view/task_screen.dart` （変更）

```
TaskScreen
  ├─ floatingActionButton: FAB
  │    onPressed → _showAddTaskDialog(context, ref)
  │      └─ AlertDialog + TextField
  │           onSubmit → ref.read(...notifier).addTask(title)
  └─ _Body
       └─ ListView.builder
            └─ state.tasks → CheckboxListTile
                 onChanged → ref.read(...notifier).updateCompletion(id, completed)
```

---

## データフロー

### タスク一覧の表示

```
TaskScreen
  ↓ ref.watch(taskScreenProvider)
TaskScreenViewModel.build()
  ↓ ref.watch(tasksStreamProvider)
TaskRepository.tasksStream
  ↓ .map(_toEntity)  // TaskItem → Task
TaskLocalServiceImpl.watchAll()
  ↓ Drift が TaskItems テーブルを監視
AppDatabase (TaskItems)
```

### タスク追加

```
TaskScreen FAB → _showAddTaskDialog → ViewModel.addTask(title)
  → TaskRepository.addTask(title: title)
  → TaskLocalService.insert(title: title)
  → Drift が DB に insert
  → watchAll() Stream が新しいリストを emit
  → tasksStreamProvider が更新
  → ViewModel.build() が自動再実行
  → View が再描画
```

### 完了状態トグル

```
TaskScreen CheckboxListTile.onChanged → ViewModel.updateCompletion(id, completed)
  → TaskRepository.updateCompletion(...)
  → TaskLocalService.updateCompletion(...)
  → Drift が DB を更新
  → watchAll() Stream が新しいリストを emit
  → tasksStreamProvider が更新
  → ViewModel.build() が自動再実行
  → View が再描画
```

---

## 作業順序

| Phase | # | 作業 | 対象ファイル | 状態 |
|-------|---|------|------------|-----|
| **Phase 1**<br>DB基盤・エンティティ | 1 | `TodoItems` → `TaskItems` にリネーム + `autoIncrement` 設定 + build_runner 再実行 | `lib/data/services/local/database/app_database.dart` | 対応済み |
| | 2 | `Task` エンティティ新規作成 + build_runner 再実行 | `lib/domain/entities/task/task.dart` | 対応済み |
| **Phase 2**<br>サービス層・リポジトリ層 | 3 | `TaskLocalService` の `TodoItem` → `TaskItem` 置換 + `insert()` 追加 | `lib/data/services/local/database/task/task_local_service.dart` | 対応済み |
| | 4 | `TaskLocalServiceImpl` の `TodoItem` → `TaskItem` 置換 + `insert()` 実装 | `lib/data/services/local/database/task/task_local_service_impl.dart` | 対応済み |
| | 5 | `TaskRepository` 新規作成（`tasksStreamProvider` も同ファイルに定義） | `lib/data/repositories/task/task_repository.dart` | 対応済み |
| **Phase 3**<br>UI層 | 6 | `TaskScreenState` に `tasks: List<Task>` 追加 + build_runner 再実行 | `lib/ui/task/view_model/task_screen_state.dart` | 対応済み |
| | 7 | `TaskScreenViewModel` を更新（stream watch・addTask・updateCompletion） | `lib/ui/task/view_model/task_screen_view_model.dart` | 対応済み |
| | 8 | `TaskScreen` を更新（FAB + ダイアログ + リスト表示 + toggle） | `lib/ui/task/view/task_screen.dart` | 対応済み |

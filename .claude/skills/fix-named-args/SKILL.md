# fix-named-args

`lib/` 配下の `.dart` ファイルを対象に位置引数違反を検知し、名前付き引数へ修正するスキル。
違反の検知ツールとして `scripts/check_named_args.dart` を実行する（修正対象はツール自体ではなく `lib/` 配下のアプリケーションコード）。

## 実行手順

### Step 1: 違反一覧を取得

まずユーザーに確認する:

> 検査対象を選択してください。
> 1. **差分のみ**（デフォルト）— 現在のブランチで変更されたファイルのみ（PR 単位の修正に最適）
> 2. **lib 配下の全件** — 全 `.dart` ファイルを一括検査

**1. 差分のみ（デフォルト）:**
```bash
git diff --cached --name-only -- 'lib/**.dart' | dart scripts/check_named_args.dart 2>&1
```
staged ファイルがない場合はブランチ差分で代替:
```bash
git diff main --name-only -- 'lib/**.dart' | dart scripts/check_named_args.dart 2>&1
```
*現時点では比較ブランチをmainとしている

**2. lib 配下の全件:**
```bash
find lib -name "*.dart" ! -name "*.freezed.dart" ! -name "*.g.dart" | xargs dart scripts/check_named_args.dart 2>&1
```

違反がなければ終了。

### Step 2: 宣言側を修正

各違反ファイルを開き、位置引数を `{...}` で囲んで名前付き引数に変換する。

**`required` の付け方は引数の性質で判断する:**

| 引数の性質 | 修正後 |
|---|---|
| 非 null 型（`String`, `int`, `bool` 等） | `required String name` |
| null 許容・必須（null を明示的に渡させる意図） | `required String? name` |
| null 許容・省略可（省略 = null と同義、省略されることが多い） | `String? name` |

**判断の目安:**
- 引数名が `option`, `filter`, `query`, `callback` 等、オプション的な意味を持つ → `required` なし
- 引数が省略されると動作が変わる（全件取得 vs フィルタあり等）→ `required` なし
- 上記に当てはまらない nullable → `required String?` をデフォルトとする

```dart
// 修正前
Future<void> setAppTheme(String theme) async { ... }
Future<List<Todo>> fetchTodos(String? statusFilter, String? query) async { ... }

// 修正後
Future<void> setAppTheme({required String theme}) async { ... }
Future<List<Todo>> fetchTodos({String? statusFilter, String? query}) async { ... }
//                              ↑ 省略可なので required なし
```

### Step 3: 呼び出し側（コールサイト）を修正

宣言を修正すると呼び出し側はコンパイルエラーになる。
`dart analyze` でエラー箇所を特定し、位置引数を名前付きに変換する。

```bash
dart analyze 2>&1 | grep "error"
```

```dart
// 修正前（コンパイルエラー）
setAppTheme('dark');
fetchTodos('completed', null);

// 修正後
setAppTheme(theme: 'dark');
fetchTodos(statusFilter: 'completed');
```

### Step 4: 検証

```bash
# 名前付き引数チェック（Step 1 と同じ範囲で再実行）
git diff --cached --name-only -- 'lib/**.dart' | dart scripts/check_named_args.dart

# 静的解析
flutter analyze
```

両方がクリアになったら完了。

## 注意事項

- `@override` メソッドは検知対象外。ただし interface / abstract 側の宣言は検知対象。
  interface を修正すると実装側もコンパイルエラーになるため、合わせて修正する。
- `@freezed` クラスのコンストラクタを修正した場合は `build_runner` を再実行する:
  ```bash
  dart run build_runner build --delete-conflicting-outputs
  ```
- 一度に大量修正すると PR が肥大化する。ファイル単位 or 機能単位で分割して修正・コミットする。

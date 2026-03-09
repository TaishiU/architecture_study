#!/bin/sh

dart fix --apply .
dart format .
#dart analyze
DART_ANALYZE_OUTPUT=$(dart analyze 2>&1)
echo "$DART_ANALYZE_OUTPUT"
if ! echo "$DART_ANALYZE_OUTPUT" | grep -q "No issues found!"; then
  echo " ❌ エラー: dart analyze で問題が検出されました。後続の処理を中断します。"
  exit 1
fi
#flutter analyze
FLUTTER_ANALYZE_OUTPUT=$(flutter analyze 2>&1)
echo "$FLUTTER_ANALYZE_OUTPUT"
if ! echo "$FLUTTER_ANALYZE_OUTPUT" | grep -q "No issues found!"; then
  echo " ❌ エラー: flutter analyze で問題が検出されました。後続の処理を中断します。"
  exit 1
fi
# ユニットテストを実行する
flutter test --coverage
# カバレッジをhtml化する
lcov --extract coverage/lcov.info 'lib/data/**/*_repository.dart' \
  --extract coverage/lcov.info 'lib/data/**/*_service_impl.dart' \
  --extract coverage/lcov.info 'lib/data/**/api_client.dart' \
  --extract coverage/lcov.info 'lib/ui/**/*_view_model.dart' \
  -o coverage/lcov_extract.info
# 自動生成ファイルを対象から除外
lcov --remove coverage/lcov_extract.info 'lib/**/*.g.dart' \
  --remove coverage/lcov_extract.info 'lib/**/*.freezed.dart' \
  -o coverage/lcov_extract.info
# HTML生成
genhtml coverage/lcov_extract.info -o coverage/html
# ブラウザで開く
open coverage/html/index.html

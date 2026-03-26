#!/bin/sh

# 色の定義
GREEN='\033[0;32m'
RED='\033[0;31m'

dart fix --apply .
dart format .
#dart analyze
DART_ANALYZE_OUTPUT=$(dart analyze 2>&1)
echo "$DART_ANALYZE_OUTPUT"
if ! echo "$DART_ANALYZE_OUTPUT" | grep -q "No issues found!"; then
  echo "${RED} ❌ エラー: dart analyze で問題が検出されました。後続の処理を中断します。"
  exit 1
fi
#flutter analyze
FLUTTER_ANALYZE_OUTPUT=$(flutter analyze 2>&1)
echo "$FLUTTER_ANALYZE_OUTPUT"
if ! echo "$FLUTTER_ANALYZE_OUTPUT" | grep -q "No issues found!"; then
  echo "${RED} ❌ エラー: flutter analyze で問題が検出されました。後続の処理を中断します。"
  exit 1
fi
# ユニットテストを実行する
flutter test --coverage
#TEST_EXIT_CODE=$?
#if [ $TEST_EXIT_CODE -ne 0 ]; then
#  echo "${RED} ❌ エラー: テストが失敗しました。"
#  exit $TEST_EXIT_CODE
#fi
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
# カバレッジ率を抽出して表示
COVERAGE=$(grep -oE "headerCovTableEntry(Lo|Med|Hi)\">[0-9.]+&nbsp;%" coverage/html/index.html | head -n 1 | sed -E 's/.*\">([0-9.]+).*/\1%/')
echo "${GREEN} 📊 [テスト完了] カバレッジ: $COVERAGE"
# ブラウザで開く
open coverage/html/index.html

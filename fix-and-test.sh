#!/bin/sh

dart fix --apply .
dart format .
flutter analyze
# ユニットテストを実行する
flutter test --coverage
# カバレッジをhtml化する
lcov --extract coverage/lcov.info 'lib/data/services/api_client.dart' \
  --extract coverage/lcov.info 'lib/data/services/*/*_service_api.dart' \
  --extract coverage/lcov.info 'lib/data/repositories/*/*_repository_api.dart' \
  --extract coverage/lcov.info 'lib/ui/*/view_model/*_view_model.dart' \
  -o coverage/lcov_extract.info
# デバッグ用のクラスおよび自動生成ファイルを対象から除外
lcov --remove coverage/lcov_extract.info 'lib/**/debug_*.dart' \
  --remove coverage/lcov_extract.info 'lib/**/*.g.dart' \
  --remove coverage/lcov_extract.info 'lib/**/*.freezed.dart' \
  -o coverage/lcov_extract.info
# HTML生成
genhtml coverage/lcov_extract.info -o coverage/html
# ブラウザで開く
open coverage/html/index.html

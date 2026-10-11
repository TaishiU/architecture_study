import 'package:hooks_riverpod/hooks_riverpod.dart';

/// APIモック切り替えフラグのProvider
final NotifierProvider<MockApiEnabledNotifier, bool> isMockApiEnabledProvider =
    NotifierProvider<MockApiEnabledNotifier, bool>(
      MockApiEnabledNotifier.new,
    );

/// APIモック切り替えフラグのNotifier
class MockApiEnabledNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  /// 現在のフラグ値
  bool get enabled => state;

  /// フラグを更新
  set enabled(bool value) => state = value;
}

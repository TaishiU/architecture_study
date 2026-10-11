import 'package:architecture_study/data/services/web_api/mock_api_enabled_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('MockApiEnabledNotifier', () {
    group('正常系', () {
      test('初期値は false であること', () {
        final value = container.read(isMockApiEnabledProvider);
        expect(value, isFalse);
      });

      test('enabled=true に設定すると state が true になること', () {
        container.read(isMockApiEnabledProvider.notifier).enabled = true;
        expect(container.read(isMockApiEnabledProvider), isTrue);
      });

      test('enabled=false に設定すると state が false になること', () {
        container.read(isMockApiEnabledProvider.notifier).enabled = true;
        container.read(isMockApiEnabledProvider.notifier).enabled = false;
        expect(container.read(isMockApiEnabledProvider), isFalse);
      });

      test('enabled ゲッターは現在の state を返すこと', () {
        final notifier = container.read(isMockApiEnabledProvider.notifier);
        expect(notifier.enabled, isFalse);
        notifier.enabled = true;
        expect(notifier.enabled, isTrue);
      });
    });
  });
}

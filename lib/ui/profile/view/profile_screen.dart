import 'package:architecture_study/ui/core/components/core_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロフィール画面
class ProfileScreen extends HookConsumerWidget {
  /// コンストラクタ
  const ProfileScreen({super.key});

  /// パス
  static const path = '/profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final asyncValue = ref.watch(ProfileScreenProvider);

    return const Scaffold(
      appBar: CoreAppBar(
        title: 'ProfileScreen',
      ),
      body: Center(
        child: Text('ProfileScreen'),
      ),
    );
  }
}

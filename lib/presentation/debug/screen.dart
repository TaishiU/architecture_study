import 'package:architecture_study/utils/talker.dart';
import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// デバッグメニュー画面（kDebugMode 限定）
class DebugMenuScreen extends StatelessWidget {
  /// コンストラクタ
  const DebugMenuScreen({super.key});

  /// パス
  static const path = '/debug';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('デバッグメニュー')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.article_outlined),
            title: const Text('ログ表示'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => TalkerScreen(talker: talker),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

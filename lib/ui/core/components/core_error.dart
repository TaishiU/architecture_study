import 'package:flutter/material.dart';

/// 共通エラークラス
///
/// 画面描画時のAsyncErrorにて表示する
class CoreError extends StatelessWidget {
  /// コンストラクタ
  const CoreError({
    required this.error,
    required this.onPressed,
    super.key,
  });

  /// エラー
  final Object error;

  /// 再読み込みボタン押下時のコールバック
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text('データの取得に失敗しました'),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: const TextStyle(color: Colors.grey, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.refresh),
            label: const Text('再読み込み'),
          ),
        ],
      ),
    );
  }
}

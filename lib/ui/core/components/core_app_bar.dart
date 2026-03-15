import 'package:flutter/material.dart';

/// 共通 [AppBar]
class CoreAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// コンストラクタ
  const CoreAppBar({
    required this.title,
    super.key,
  });

  /// タイトル
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

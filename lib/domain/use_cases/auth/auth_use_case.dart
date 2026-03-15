import 'package:architecture_study/data/repositories/auth/auth_repository.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// ログイン済みかどうか
Future<bool> checkIsLoggedIn(Ref ref) async {
  final isLoggedIn = await ref.read(authRepositoryProvider).isLoggedIn;
  return isLoggedIn;
}

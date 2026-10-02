import 'package:architecture_study/data/repositories/user/user_repository.dart';
import 'package:architecture_study/domain/use_cases/auth/auth_use_case.dart';
import 'package:architecture_study/presentation/profile/state.dart';
import 'package:architecture_study/utils/logger.dart';
import 'package:architecture_study/utils/result.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// プロバイダ
final AsyncNotifierProvider<ProfileScreenNotifier, ProfileScreenState>
profileScreenProvider =
    AsyncNotifierProvider.autoDispose<
      ProfileScreenNotifier,
      ProfileScreenState
    >(
      ProfileScreenNotifier.new,
    );

/// プロフィール画面のNotifier
class ProfileScreenNotifier extends AsyncNotifier<ProfileScreenState> {
  @override
  Future<ProfileScreenState> build() async {
    final result = await ref.read(userRepositoryProvider).fetch();

    return switch (result) {
      SuccessResult(:final value) => ProfileScreenState(
        hasProfile: false,
        user: value,
      ),
      FailureResult(:final error) => () {
        logger.e('[ProfileScreenNotifier] Error caught: $error');
        throw error;
      }(),
    };
  }

  /// データの再読み込みを行う
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// ログアウトを実行する
  Future<void> logout() async {
    await ref.read(authUseCaseProvider).logout();
  }
}

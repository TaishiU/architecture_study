part of 'state.dart';

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

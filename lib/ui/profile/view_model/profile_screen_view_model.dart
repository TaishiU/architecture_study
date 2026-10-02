part of 'profile_screen_state.dart';

/// プロバイダ
final AsyncNotifierProvider<ProfileScreenViewModel, ProfileScreenState>
profileScreenProvider =
    AsyncNotifierProvider.autoDispose<
      ProfileScreenViewModel,
      ProfileScreenState
    >(
      ProfileScreenViewModel.new,
    );

/// プロフィール画面のViewModel
class ProfileScreenViewModel extends AsyncNotifier<ProfileScreenState> {
  @override
  Future<ProfileScreenState> build() async {
    final result = await ref.read(userRepositoryProvider).fetch();

    return switch (result) {
      SuccessResult(:final value) => ProfileScreenState(
        hasProfile: false,
        user: value,
      ),
      FailureResult(:final error) => () {
        logger.e('[ProfileScreenViewModel] Error caught: $error');
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

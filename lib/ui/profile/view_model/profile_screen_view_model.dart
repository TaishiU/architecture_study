part of 'profile_screen_state.dart';

/// プロバイダ
final AsyncNotifierProvider<ProfileScreenViewModel, Result<ProfileScreenState>>
profileScreenProvider =
    AsyncNotifierProvider.autoDispose<
      ProfileScreenViewModel,
      Result<ProfileScreenState>
    >(
      ProfileScreenViewModel.new,
    );

/// プロフィール画面のViewModel
class ProfileScreenViewModel extends AsyncNotifier<Result<ProfileScreenState>> {
  @override
  Future<Result<ProfileScreenState>> build() async {
    final result = await ref.watch(userRepositoryProvider).fetch();

    return switch (result) {
      SuccessResult(value: final user) => SuccessResult(
        ProfileScreenState(
          hasProfile: false,
          user: user,
        ),
      ),
      FailureResult(:final error) => () {
        logger.e('[ProfileScreenViewModel] Error caught: $error');
        return FailureResult<ProfileScreenState>(error);
      }(),
    };
  }

  /// データの再読み込みを行う
  Future<void> refresh() async {
    // 自身のProviderを破棄して0から再構築する。
    ref.invalidateSelf();
  }

  /// ログアウトを実行する
  Future<void> logout() async {
    final authUseCase = ref.read(authUseCaseProvider);
    await authUseCase.logout();
  }
}

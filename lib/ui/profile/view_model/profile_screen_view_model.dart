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
    try {
      final user = await fetchUser();
      return ProfileScreenState(
        hasProfile: false,
        user: user,
      );
    } on Exception catch (error) {
      logger.e('[ProfileScreenViewModel] $error');
      rethrow;
    }
  }

  /// [User] を取得
  Future<User> fetchUser() async {
    final result = await ref.read(userRepositoryProvider).fetch();

    switch (result) {
      case SuccessResult<User>():
        return result.value;
      case FailureResult<User>():
        logger.e(
          '[ProfileScreenViewModel] fetchUser failed: ${result.error}',
        );
        throw result.error;
    }
  }

  /// データの再読み込みを行う
  Future<void> refresh() async {
    // 1. Repositoryに対し、SSOTを強制的に最新に更新するように依頼する
    // await ref.read(userRepositoryProvider).fetch();

    // 2. 自身のProviderを破棄して0から再構築する。
    //    これにより、build() が実行され、UI固有の状態（searchQueryなど）も初期値に戻る。
    ref.invalidateSelf();
  }
}

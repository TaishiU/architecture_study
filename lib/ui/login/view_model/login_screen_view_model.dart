part of 'login_screen_state.dart';

/// LoginScreenViewModelのプロバイダ
final AsyncNotifierProvider<LoginScreenViewModel, LoginScreenState>
loginScreenProvider =
    AsyncNotifierProvider.autoDispose<LoginScreenViewModel, LoginScreenState>(
      LoginScreenViewModel.new,
    );

/// ログイン画面のViewModel
class LoginScreenViewModel extends AsyncNotifier<LoginScreenState> {
  @override
  Future<LoginScreenState> build() async {
    return const LoginScreenState(
      isLoggedIn: false,
    );
  }

  /// ログイン
  Future<void> login({
    required String username,
    required String password,
  }) async {
    final authUseCase = ref.read(authUseCaseProvider);
    final result = await authUseCase.login(
      username: username,
      password: password,
    );

    switch (result) {
      case SuccessResult<void>():
        // final value = state.value;
        // if (value == null) {
        //   return;
        // }
        // ログイン状態は AuthRepository の通知によって GoRouter が検知し、
        // 自動的にホーム画面へリダイレクトされるため、ここで state を変更する必要はないが、
        // 必要に応じて UI のフィードバック処理を行う。
        return;
      case FailureResult<void>():
        logger.e('[LoginScreenViewModel] login failed: ${result.error}');
        throw Exception();
    }
  }
}

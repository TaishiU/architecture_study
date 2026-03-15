part of 'login_screen_state.dart';

/// プロバイダ
final loginScreenProvider =
    AsyncNotifierProvider<LoginScreenViewModel, LoginScreenState>(
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
  Future<void> login() async {
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authRepository.login();

    switch (result) {
      case SuccessResult<void>():
        final value = state.value;
        if (value == null) {
          return;
        }
        // state = AsyncData(
        //   value.copyWith(
        //     isLoggedIn: true,
        //   ),
        // );
        return result.value;
      case FailureResult<void>():
        logger.e('[LoginScreenViewModel] login failed: ${result.error}');
        throw Exception();
    }
  }
}

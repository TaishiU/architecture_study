part of 'profile_screen_state.dart';

/// プロバイダ
final profileScreenProvider =
    AsyncNotifierProvider<ProfileScreenViewModel, ProfileScreenState>(
      ProfileScreenViewModel.new,
    );

/// プロフィール画面のViewModel
class ProfileScreenViewModel extends AsyncNotifier<ProfileScreenState> {
  @override
  Future<ProfileScreenState> build() async {
    try {
      return const ProfileScreenState(hasProfile: false);
    } on Exception catch (error) {
      logger.e('[ProfileScreenViewModel] $error');
      throw Exception();
    }
  }
}

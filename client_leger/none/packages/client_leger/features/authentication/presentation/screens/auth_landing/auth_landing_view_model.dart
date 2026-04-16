import '../../../../../routing/app_navigator.dart';
import '../../../../../routing/navigation_command.dart';

class AuthLandingViewModel {
  AuthLandingViewModel({required AppNavigator appNavigator})
    : _appNavigator = appNavigator;

  final AppNavigator _appNavigator;

  void goToLogin() {
    _appNavigator.request(GoToLogin());
  }

  void goToSignUp() {
    _appNavigator.request(GoToSignUp());
  }
}

import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../app_transition/friends_events.dart';

class FriendsCoordinator {
  FriendsCoordinator({required AppNavigator appNavigator})
    : _appNavigator = appNavigator;

  final AppNavigator _appNavigator;

  Future<void> onEntry(FriendsEntryAppEvent event) async {
    switch (event) {
      case FriendsRequested():
        _appNavigator.request(GoToFriends());
    }
  }

  Future<void> onExit(FriendsExitAppEvent event) async {
    switch (event) {
      case FriendsLeaveRequested():
        _appNavigator.request(ExitToMainMenu());
    }
  }
}

import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../app_transition/discussion_canals_events.dart';

class DiscussionCanalsCoordinator {
  DiscussionCanalsCoordinator({required AppNavigator appNavigator})
    : _appNavigator = appNavigator;

  final AppNavigator _appNavigator;

  Future<void> onEntry(DiscussionCanalsEntryAppEvent event) async {
    switch (event) {
      case DiscussionCanalsRequested():
        _appNavigator.request(GoToDiscussionCanals());
    }
  }

  Future<void> onExit(DiscussionCanalsExitAppEvent event) async {
    switch (event) {
      case DiscussionCanalsLeaveRequested():
        _appNavigator.request(ExitToMainMenu());
    }
  }
}

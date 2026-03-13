import '../../../../core/app_transition/feature_coordinator.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../app_events/profile_events.dart';

class ProfileCoordinator
    implements
        FeatureCoordinator<
          ProfileEntryAppEvent,
          ProfileCompletedAppEvent,
          ProfileExitAppEvent> {
  ProfileCoordinator({required this.appNavigator});

  final AppNavigator appNavigator;

  @override
  Future<void> onEntry(ProfileEntryAppEvent event) async {
    appNavigator.request(GoToProfile());
  }

  @override
  Future<void> onCompleted(ProfileCompletedAppEvent event) async {}

  @override
  Future<void> onExit(ProfileExitAppEvent event) async {
    appNavigator.request(ExitToMainMenu());
  }
}


import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../data/services/http_tutorial_service.dart';
import '../app_transition/tutorial_events.dart';

class TutorialCoordinator {
  TutorialCoordinator({
    required AppNavigator appNavigator,
    required HttpTutorialService tutorialService,
  }) : _appNavigator = appNavigator,
       _tutorialService = tutorialService;

  final AppNavigator _appNavigator;
  final HttpTutorialService _tutorialService;

  Future<void> onEntry(TutorialEntryAppEvent event) async {
    switch (event) {
      case TutorialRequested():
        _appNavigator.request(GoToTutorial());
    }
  }

  Future<void> onExit(TutorialExitAppEvent event) async {
    switch (event) {
      case TutorialLeaveRequested():
        _appNavigator.request(ExitToMainMenu());
    }
  }

  Future<void> checkAndLaunchTutorial() async {
    final progress = await _tutorialService.fetchProgress();

    if (!progress.started) {
      _appNavigator.request(GoToTutorial());
    } else {}
  }
}

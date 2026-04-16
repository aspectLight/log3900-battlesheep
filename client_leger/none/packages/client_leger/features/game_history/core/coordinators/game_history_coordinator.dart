import '../../../../core/app_transition/feature_coordinator.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../app_events/game_history_events.dart';

class GameHistoryCoordinator
    implements
        FeatureCoordinator<
          GameHistoryEntryAppEvent,
          GameHistoryCompletedAppEvent,
          GameHistoryExitAppEvent
        > {
  GameHistoryCoordinator({required this.appNavigator});

  final AppNavigator appNavigator;

  @override
  Future<void> onEntry(GameHistoryEntryAppEvent event) async {
    appNavigator.request(GoToGameHistory());
  }

  @override
  Future<void> onCompleted(GameHistoryCompletedAppEvent event) async {}

  @override
  Future<void> onExit(GameHistoryExitAppEvent event) async {
    appNavigator.request(ExitToMainMenu());
  }
}

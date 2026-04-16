import '../../../../core/app_transition/feature_coordinator.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../app_events/logs_history_events.dart';

class LogsHistoryCoordinator
    implements
        FeatureCoordinator<
          LogsHistoryEntryAppEvent,
          LogsHistoryCompletedAppEvent,
          LogsHistoryExitAppEvent
        > {
  LogsHistoryCoordinator({required this.appNavigator});

  final AppNavigator appNavigator;

  @override
  Future<void> onEntry(LogsHistoryEntryAppEvent event) async {
    appNavigator.request(GoToLogsHistory());
  }

  @override
  Future<void> onCompleted(LogsHistoryCompletedAppEvent event) async {}

  @override
  Future<void> onExit(LogsHistoryExitAppEvent event) async {
    appNavigator.request(ExitToMainMenu());
  }
}

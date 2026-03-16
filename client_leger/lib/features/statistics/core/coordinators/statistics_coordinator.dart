import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/app_transition/auto_scope_coordinator.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../data/models/extensions/statistics_dto_extensions.dart';
import '../../data/services/statistics_socket.dart';
import '../app_events/statistics_events.dart';
import '../context/statistics_data.dart';
import '../context/statistics_scope_holder.dart';
import '../di/statistics_module.dart';

class StatisticsCoordinator
    extends
    AutoScopeCoordinator<
        StatisticsData,
        StatisticsEntryAppEvent,
        StatisticsCompletedAppEvent,
        StatisticsExitAppEvent> {
  StatisticsCoordinator({
    required this.getIt,
    required this.sessionScopeManager,
    required this.statisticsScopeHolder,
    required this.appNavigator,
    required this.appTransitionEventBus,
    required StatisticsSocket statisticsSocket,
  }) : _statisticsSocket = statisticsSocket;

  final GetIt getIt;
  @override
  final SessionScopeManager sessionScopeManager;
  final StatisticsScopeHolder statisticsScopeHolder;
  final AppNavigator appNavigator;
  final AppTransitionEventBus appTransitionEventBus;
  final StatisticsSocket _statisticsSocket;

  @override
  final String scopeName = 'statistics';

  @override
  void onScopeCreated(GetIt scope) {
    statisticsScopeHolder.setScope(scope);
    registerStatisticsScope(
      scope,
      getIt,
      initialData: entryData.initialData,
      isCTF: entryData.isCTF,
    );
    bootstrapStatisticsScope(scope);
  }

  @override
  Future<StatisticsData?> onEntryImpl(StatisticsEntryAppEvent event) async {
    if (event is! StatisticsRequested) return null;
    _statisticsSocket.getStatistics(event.roomId);
    final dto = await _statisticsSocket.statisticsResponseStream.first;
    appNavigator.request(GoToStatistics());
    appTransitionEventBus.fire(const StatisticsCompletedAppEvent());
    return StatisticsData(
      roomId: event.roomId,
      initialData: dto.toEntity(),
      isCTF: event.isCTF,
    );
  }

  @override
  Future<void> onCompletedImpl(
    StatisticsCompletedAppEvent event,
    StatisticsData data,
  ) async {}

  @override
  Future<void> onExitImpl(
    StatisticsExitAppEvent event,
    StatisticsData data,
  ) async {
    statisticsScopeHolder.clearScope();
    appNavigator.request(ExitToMainMenu());
  }
}

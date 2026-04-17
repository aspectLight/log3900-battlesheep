import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/app_transition/auto_scope_coordinator.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/services/log_service.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../data/models/extensions/game_rewards_info_dto_extensions.dart';
import '../../data/models/extensions/statistics_dto_extensions.dart';
import '../../data/services/statistics_socket.dart';
import '../app_events/statistics_events.dart';
import '../context/statistics_data.dart';
import '../context/statistics_scope_holder.dart';
import '../di/statistics_module.dart';
import '../../domain/models/game_rewards_info.dart';

class StatisticsCoordinator
    extends
        AutoScopeCoordinator<
          StatisticsData,
          StatisticsEntryAppEvent,
          StatisticsCompletedAppEvent,
          StatisticsExitAppEvent
        > {
  StatisticsCoordinator({
    required this.getIt,
    required this.sessionScopeManager,
    required this.statisticsScopeHolder,
    required this.appNavigator,
    required this.appTransitionEventBus,
  });

  final GetIt getIt;
  @override
  final SessionScopeManager sessionScopeManager;
  final StatisticsScopeHolder statisticsScopeHolder;
  final AppNavigator appNavigator;
  final AppTransitionEventBus appTransitionEventBus;
  GameRewardsInfo _initialRewards = GameRewardsInfo.empty;

  @override
  final String scopeName = 'statistics';

  @override
  void onScopeCreated(GetIt scope) {
    statisticsScopeHolder.setScope(scope);
    registerStatisticsScope(
      scope,
      getIt,
      initialData: entryData.initialData,
      initialRewards: _initialRewards,
      isCTF: entryData.isCTF,
      winnerId: entryData.winnerId,
      currentUserSocketId: entryData.currentUserSocketId,
      statisticsPlayerName: entryData.statisticsPlayerName,
    );
    bootstrapStatisticsScope(scope);
  }

  @override
  Future<StatisticsData?> onEntryImpl(StatisticsEntryAppEvent event) async {
    if (event is! StatisticsRequested) return null;
    final captured = event.capturedRewards;
    LogService.d('[StatsCoord] onEntryImpl capturedRewards=${captured?.rewards.length ?? "null"} entryFee=${captured?.entryFee} pool=${captured?.pool}');
    _initialRewards = captured ?? GameRewardsInfo.empty;
    final statisticsSocket = StatisticsSocket(
      socketService: getIt<SocketService>(),
    );
    final rewardsSubscription = statisticsSocket.rewardsInfoStream.listen((
      dto,
    ) {
      final entity = dto.toEntity();
      LogService.d('[StatsCoord] live rewardsInfoStream received: ${entity.rewards.length} reward(s)');
      _initialRewards = entity;
    });
    statisticsSocket.getStatistics(event.roomId);
    try {
      final dto = await statisticsSocket.statisticsResponseStream.first;
      LogService.d('[StatsCoord] getStatisticsResponse received, navigating. _initialRewards has ${_initialRewards.rewards.length} reward(s)');
      appNavigator.request(GoToStatistics());
      appTransitionEventBus.fire(const StatisticsCompletedAppEvent());
      return StatisticsData(
        roomId: event.roomId,
        initialData: dto.toEntity(),
        isCTF: event.isCTF,
        winnerId: event.winnerId,
        currentUserSocketId: event.currentUserSocketId,
        statisticsPlayerName: event.statisticsPlayerName,
      );
    } finally {
      LogService.d('[StatsCoord] finally: disposing temp socket. _initialRewards has ${_initialRewards.rewards.length} reward(s)');
      await rewardsSubscription.cancel();
      await statisticsSocket.dispose();
    }
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
    _initialRewards = GameRewardsInfo.empty;
    statisticsScopeHolder.clearScope();
    appNavigator.request(ExitToMainMenu());
  }
}

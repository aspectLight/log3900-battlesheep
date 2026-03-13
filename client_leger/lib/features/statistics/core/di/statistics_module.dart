import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/di/scoped_projection_subscriptions.dart';
import '../../../../core/services/socket_service.dart';
import '../context/statistics_scope_holder.dart';
import '../../../../routing/app_navigator.dart';
import '../../data/projections/statistics_events_projection.dart';
import '../../data/services/statistics_socket.dart';
import '../../domain/models/game_statistics.dart';
import '../coordinators/statistics_coordinator.dart';
import 'statistics_projection_module.dart';
import 'statistics_repository_module.dart';
import 'statistics_view_model_module.dart';

void registerStatisticsRoot(GetIt getIt) {
  getIt.registerLazySingleton<StatisticsScopeHolder>(StatisticsScopeHolder.new);
  getIt.registerLazySingleton<StatisticsSocket>(
    () => StatisticsSocket(socketService: getIt.get<SocketService>()),
  );
  getIt.registerLazySingleton<StatisticsCoordinator>(
    () => StatisticsCoordinator(
      getIt: getIt,
      sessionScopeManager: getIt<SessionScopeManager>(),
      statisticsScopeHolder: getIt<StatisticsScopeHolder>(),
      appNavigator: getIt<AppNavigator>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      statisticsSocket: getIt<StatisticsSocket>(),
    ),
  );
}

void registerStatisticsScope(
  GetIt scope,
  GetIt rootGetIt, {
  required GameStatistics initialData,
  required bool isCTF,
}) {
  registerStatisticsRepositories(scope, initialData: initialData);
  registerStatisticsProjections(scope, rootGetIt);
  registerStatisticsViewModels(scope, rootGetIt, isCTF: isCTF);
}

void bootstrapStatisticsScope(GetIt scope) {
  registerScopedProjectionSubscriptions(
    scope,
    scope.get<StatisticsEventsProjection>().subscribe(),
  );
}

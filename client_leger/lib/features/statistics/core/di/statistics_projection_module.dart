import 'package:get_it/get_it.dart';

import '../../data/projections/statistics_events_projection.dart';
import '../../data/repositories/statistics_repository.dart';
import '../../data/services/statistics_socket.dart';

void registerStatisticsProjections(GetIt scope, GetIt rootGetIt) {
  scope.registerLazySingleton<StatisticsEventsProjection>(
    () => StatisticsEventsProjection(
      statisticsSocket: rootGetIt.get<StatisticsSocket>(),
      statisticsRepository: scope.get<StatisticsRepository>(),
    ),
  );
}

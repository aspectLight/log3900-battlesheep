import 'package:get_it/get_it.dart';

import '../../data/repositories/statistics_repository.dart';
import '../../domain/models/game_statistics.dart';

void registerStatisticsRepositories(
  GetIt scope, {
  required GameStatistics initialData,
}) {
  scope.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepository(initialData: initialData),
  );
}

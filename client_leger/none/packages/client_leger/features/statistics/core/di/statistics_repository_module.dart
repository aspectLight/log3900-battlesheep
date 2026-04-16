import 'package:get_it/get_it.dart';

import '../../data/repositories/statistics_repository.dart';
import '../../domain/models/game_rewards_info.dart';
import '../../domain/models/game_statistics.dart';

void registerStatisticsRepositories(
  GetIt scope, {
  required GameStatistics initialData,
  required GameRewardsInfo initialRewards,
}) {
  scope.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepository(
      initialData: initialData,
      initialRewards: initialRewards,
    ),
  );
}

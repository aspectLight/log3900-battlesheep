import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/services/log_service.dart';
import '../../domain/models/game_rewards_info.dart';
import '../../domain/models/game_statistics.dart';
import '../../domain/state/statistics_state.dart';

class StatisticsRepository {
  late final Signal<StatisticsState> state;
  late final Signal<GameRewardsInfo> rewardsInfo;

  StatisticsRepository({
    required GameStatistics initialData,
    GameRewardsInfo initialRewards = GameRewardsInfo.empty,
  }) : state = signal(StatisticsState(data: initialData)),
       rewardsInfo = signal(initialRewards) {
    LogService.d('[StatsRepo] created with initialRewards: ${initialRewards.rewards.length} reward(s), entryFee=${initialRewards.entryFee}');
  }

  void applyStatistics(GameStatistics statistics) {
    state.value = StatisticsState(data: statistics);
  }

  void applyRewardsInfo(GameRewardsInfo rewards) {
    LogService.d('[StatsRepo] applyRewardsInfo: ${rewards.rewards.length} reward(s), entryFee=${rewards.entryFee}, pool=${rewards.pool}');
    rewardsInfo.value = rewards;
  }
}

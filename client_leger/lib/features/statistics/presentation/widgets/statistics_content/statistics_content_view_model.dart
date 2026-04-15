import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/app_events/statistics_events.dart';
import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/enums/player_stats_sort_field.dart';
import '../../../data/repositories/statistics_repository.dart';
import '../../../domain/models/game_rewards_info.dart';
import '../../../domain/models/game_statistics.dart';

class StatisticsContentViewModel {
  final AppTransitionEventBus _appTransitionEventBus;
  final StatisticsRepository _statisticsRepository;
  final bool isCTF;

  final sortField = signal<PlayerStatsSortField>(PlayerStatsSortField.name);
  final isAscending = signal<bool>(false);

  late final statistics = computed(() => _statisticsRepository.state.value);
  late final rewards = computed(() => _statisticsRepository.rewardsInfo.value);
  late final rewardsRows = computed<List<PlayerRewardInfo>>(
    () => rewards.value.rewards,
  );

  late final sortedPlayerStats = computed(() {
    final players = List<PlayerStatistics>.from(
      statistics.value.data.playerStats,
    );
    final field = sortField.value;
    final ascending = isAscending.value;
    players.sort((a, b) {
      final comparison = switch (field) {
        PlayerStatsSortField.name => a.name.compareTo(b.name),
        PlayerStatsSortField.combats => a.combats.compareTo(b.combats),
        PlayerStatsSortField.evasions => a.evasions.compareTo(b.evasions),
        PlayerStatsSortField.victories => a.victories.compareTo(b.victories),
        PlayerStatsSortField.defeats => a.defeats.compareTo(b.defeats),
        PlayerStatsSortField.healthLost => a.healthLost.compareTo(b.healthLost),
        PlayerStatsSortField.damage => a.damage.compareTo(b.damage),
        PlayerStatsSortField.itemsCollected =>
          a.itemsCollected.length.compareTo(b.itemsCollected.length),
        PlayerStatsSortField.tilesVisited => a.tilesVisited.length.compareTo(
          b.tilesVisited.length,
        ),
      };
      return ascending ? comparison : -comparison;
    });
    return players;
  });

  StatisticsContentViewModel({
    required AppTransitionEventBus appTransitionEventBus,
    required StatisticsRepository statisticsRepository,
    required this.isCTF,
  }) : _appTransitionEventBus = appTransitionEventBus,
       _statisticsRepository = statisticsRepository;

  void sortBy(PlayerStatsSortField field) {
    if (sortField.value == field) {
      isAscending.value = !isAscending.value;
    } else {
      sortField.value = field;
      isAscending.value = false;
    }
  }

  void requestLeave() {
    _appTransitionEventBus.fire(const LeaveStatisticsRequestedCommand());
  }

  void dispose() {}
}

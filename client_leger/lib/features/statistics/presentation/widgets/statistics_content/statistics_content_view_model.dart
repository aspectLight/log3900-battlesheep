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

  /// Active column for player stats (matches Angular `sortedProperty`).
  final sortField = signal<PlayerStatsSortField>(PlayerStatsSortField.name);
  /// Matches Angular `isAscending` **after** each `sortBy` (post-toggle). The
  /// comparator uses `!isAscending` so the first effective sort is descending
  /// by name, same as `sortBy('name')` in `end-game.component.ts`.
  final isAscending = signal<bool>(true);

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
    // Angular sorts with `isAscending` *before* each click, then toggles.
    // Our signal holds the value *after* the last toggle, so invert here.
    final useAscendingOrder = !isAscending.value;
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
      return useAscendingOrder ? comparison : -comparison;
    });
    return players;
  });

  StatisticsContentViewModel({
    required AppTransitionEventBus appTransitionEventBus,
    required StatisticsRepository statisticsRepository,
    required this.isCTF,
  }) : _appTransitionEventBus = appTransitionEventBus,
       _statisticsRepository = statisticsRepository;

  /// Same behavior as Angular `EndGameComponent.sortBy`: sort by the clicked
  /// column using the current direction, then flip direction for the next sort.
  void sortBy(PlayerStatsSortField field) {
    sortField.value = field;
    isAscending.value = !isAscending.value;
  }

  void requestLeave() {
    _appTransitionEventBus.fire(const LeaveStatisticsRequestedCommand());
  }

  void dispose() {}
}

import 'package:freezed_annotation/freezed_annotation.dart';

import 'statistics_board_position.dart';

part 'game_statistics.freezed.dart';

@freezed
class PlayerStatistics with _$PlayerStatistics {
  const factory PlayerStatistics({
    required String name,
    required int combats,
    required int evasions,
    required int victories,
    required int defeats,
    required int healthLost,
    required int damage,
    required List<String> itemsCollected,
    required List<StatisticsBoardPosition> tilesVisited,
  }) = _PlayerStatistics;
}

@freezed
class GlobalStatistics with _$GlobalStatistics {
  const factory GlobalStatistics({
    required String gameDuration,
    required int turns,
    required List<StatisticsBoardPosition> doorsToggled,
  }) = _GlobalStatistics;
}

@freezed
class GameStatistics with _$GameStatistics {
  const factory GameStatistics({
    required List<PlayerStatistics> playerStats,
    required GlobalStatistics globalStats,
    required int walkableTiles,
    required int toggableDoors,
  }) = _GameStatistics;
}

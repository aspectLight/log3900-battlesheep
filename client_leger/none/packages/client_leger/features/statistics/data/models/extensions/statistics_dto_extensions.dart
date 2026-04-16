import '../../../domain/models/game_statistics.dart';
import 'statistics_board_position_dto_extensions.dart';
import '../dto/statistics_dto.dart';

extension PlayerStatisticsDtoToEntity on PlayerStatisticsDto {
  PlayerStatistics toEntity() => PlayerStatistics(
    name: name,
    combats: combats,
    evasions: evasions,
    victories: victories,
    defeats: defeats,
    healthLost: healthLost,
    damage: damage,
    itemsCollected: itemsCollected,
    tilesVisited: tilesVisited.map((tile) => tile.toEntity()).toList(),
  );
}

extension GlobalStatisticsDtoToEntity on GlobalStatisticsDto {
  GlobalStatistics toEntity() => GlobalStatistics(
    gameDuration: gameDuration,
    turns: turns,
    doorsToggled: doorsToggled.map((door) => door.toEntity()).toList(),
  );
}

extension GameStatisticsDtoToEntity on GameStatisticsDto {
  GameStatistics toEntity() => GameStatistics(
    playerStats: playerStats.map((stat) => stat.toEntity()).toList(),
    globalStats: globalStats.toEntity(),
    walkableTiles: globalStats.walkableTiles,
    toggableDoors: globalStats.toggableDoors,
  );
}

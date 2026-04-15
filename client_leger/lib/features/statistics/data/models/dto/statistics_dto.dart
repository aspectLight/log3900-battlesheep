import 'package:json_annotation/json_annotation.dart';

import 'statistics_board_position_dto.dart';

part 'statistics_dto.g.dart';

@JsonSerializable()
class PlayerStatisticsDto {
  final String name;
  final int combats;
  final int evasions;
  final int victories;
  final int defeats;
  final int healthLost;
  final int damage;
  final List<String> itemsCollected;
  final List<StatisticsBoardPositionDto> tilesVisited;

  const PlayerStatisticsDto({
    required this.name,
    required this.combats,
    required this.evasions,
    required this.victories,
    required this.defeats,
    required this.healthLost,
    required this.damage,
    required this.itemsCollected,
    required this.tilesVisited,
  });

  factory PlayerStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerStatisticsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerStatisticsDtoToJson(this);
}

@JsonSerializable()
class GlobalStatisticsDto {
  final String gameDuration;
  final int turns;
  final List<StatisticsBoardPositionDto> doorsToggled;
  final int walkableTiles;
  final int toggableDoors;

  const GlobalStatisticsDto({
    required this.gameDuration,
    required this.turns,
    required this.doorsToggled,
    required this.walkableTiles,
    required this.toggableDoors,
  });

  factory GlobalStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$GlobalStatisticsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GlobalStatisticsDtoToJson(this);
}

@JsonSerializable()
class GameStatisticsDto {
  final List<PlayerStatisticsDto> playerStats;
  final GlobalStatisticsDto globalStats;

  const GameStatisticsDto({
    required this.playerStats,
    required this.globalStats,
  });

  factory GameStatisticsDto.fromJson(Map<String, dynamic> json) =>
      _$GameStatisticsDtoFromJson(json);

  factory GameStatisticsDto.fromSocketData(Map<String, dynamic> data) =>
      GameStatisticsDto.fromJson(data);

  Map<String, dynamic> toJson() => _$GameStatisticsDtoToJson(this);
}

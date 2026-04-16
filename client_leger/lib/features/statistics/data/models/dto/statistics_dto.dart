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

  factory GameStatisticsDto.fromSocketData(Map<String, dynamic> data) {
    final globalStatsData = _asMap(data['globalStats']);

    final walkableTiles =
        _asInt(globalStatsData['walkableTiles']) ??
        _asInt(data['walkableTiles']);
    final toggableDoors =
        _asInt(globalStatsData['toggableDoors']) ??
        _asInt(data['toggableDoors']);

    final parsedGlobalStats = GlobalStatisticsDto(
      gameDuration: _asString(globalStatsData['gameDuration']) ?? '00:00',
      turns: _asInt(globalStatsData['turns']) ?? 0,
      doorsToggled: _parseBoardPositions(globalStatsData['doorsToggled']),
      walkableTiles: walkableTiles ?? 0,
      toggableDoors: toggableDoors ?? 0,
    );

    final playerStatsRaw = data['playerStats'];
    final parsedPlayerStats = playerStatsRaw is List
        ? playerStatsRaw
              .whereType<Map>()
              .map((raw) => _parsePlayerStats(raw.cast<String, dynamic>()))
              .toList()
        : <PlayerStatisticsDto>[];

    return GameStatisticsDto(
      playerStats: parsedPlayerStats,
      globalStats: parsedGlobalStats,
    );
  }

  Map<String, dynamic> toJson() => _$GameStatisticsDtoToJson(this);
}

PlayerStatisticsDto _parsePlayerStats(Map<String, dynamic> data) {
  return PlayerStatisticsDto(
    name: _asString(data['name']) ?? '',
    combats: _asInt(data['combats']) ?? 0,
    evasions: _asInt(data['evasions']) ?? 0,
    victories: _asInt(data['victories']) ?? 0,
    defeats: _asInt(data['defeats']) ?? 0,
    healthLost: _asInt(data['healthLost']) ?? 0,
    damage: _asInt(data['damage']) ?? 0,
    itemsCollected: data['itemsCollected'] is List
        ? (data['itemsCollected'] as List).whereType<String>().toList()
        : <String>[],
    tilesVisited: _parseBoardPositions(data['tilesVisited']),
  );
}

List<StatisticsBoardPositionDto> _parseBoardPositions(dynamic raw) {
  if (raw is! List) {
    return <StatisticsBoardPositionDto>[];
  }

  return raw
      .whereType<Map>()
      .map((entry) => entry.cast<String, dynamic>())
      .map(
        (position) => StatisticsBoardPositionDto(
          x: _asInt(position['x']) ?? 0,
          y: _asInt(position['y']) ?? 0,
        ),
      )
      .toList();
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.cast<String, dynamic>();
  }
  return <String, dynamic>{};
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return null;
}

String? _asString(dynamic value) {
  if (value is String) return value;
  return null;
}

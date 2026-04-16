// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerStatisticsDto _$PlayerStatisticsDtoFromJson(Map<String, dynamic> json) =>
    PlayerStatisticsDto(
      name: json['name'] as String,
      combats: (json['combats'] as num).toInt(),
      evasions: (json['evasions'] as num).toInt(),
      victories: (json['victories'] as num).toInt(),
      defeats: (json['defeats'] as num).toInt(),
      healthLost: (json['healthLost'] as num).toInt(),
      damage: (json['damage'] as num).toInt(),
      itemsCollected: (json['itemsCollected'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      tilesVisited: (json['tilesVisited'] as List<dynamic>)
          .map(
            (e) =>
                StatisticsBoardPositionDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$PlayerStatisticsDtoToJson(
  PlayerStatisticsDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'combats': instance.combats,
  'evasions': instance.evasions,
  'victories': instance.victories,
  'defeats': instance.defeats,
  'healthLost': instance.healthLost,
  'damage': instance.damage,
  'itemsCollected': instance.itemsCollected,
  'tilesVisited': instance.tilesVisited,
};

GlobalStatisticsDto _$GlobalStatisticsDtoFromJson(Map<String, dynamic> json) =>
    GlobalStatisticsDto(
      gameDuration: json['gameDuration'] as String,
      turns: (json['turns'] as num).toInt(),
      doorsToggled: (json['doorsToggled'] as List<dynamic>)
          .map(
            (e) =>
                StatisticsBoardPositionDto.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      walkableTiles: (json['walkableTiles'] as num).toInt(),
      toggableDoors: (json['toggableDoors'] as num).toInt(),
    );

Map<String, dynamic> _$GlobalStatisticsDtoToJson(
  GlobalStatisticsDto instance,
) => <String, dynamic>{
  'gameDuration': instance.gameDuration,
  'turns': instance.turns,
  'doorsToggled': instance.doorsToggled,
  'walkableTiles': instance.walkableTiles,
  'toggableDoors': instance.toggableDoors,
};

GameStatisticsDto _$GameStatisticsDtoFromJson(Map<String, dynamic> json) =>
    GameStatisticsDto(
      playerStats: (json['playerStats'] as List<dynamic>)
          .map((e) => PlayerStatisticsDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      globalStats: GlobalStatisticsDto.fromJson(
        json['globalStats'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$GameStatisticsDtoToJson(GameStatisticsDto instance) =>
    <String, dynamic>{
      'playerStats': instance.playerStats,
      'globalStats': instance.globalStats,
    };

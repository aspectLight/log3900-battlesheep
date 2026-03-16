// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiting_room_player_stats_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaitingRoomPlayerStatsDto _$WaitingRoomPlayerStatsDtoFromJson(
  Map<String, dynamic> json,
) => WaitingRoomPlayerStatsDto(
  health: WaitingRoomPlayerStatValueDto.fromJson(
    json['health'] as Map<String, dynamic>,
  ),
  speed: WaitingRoomPlayerStatValueDto.fromJson(
    json['speed'] as Map<String, dynamic>,
  ),
  attack: WaitingRoomPlayerStatValueDto.fromJson(
    json['attack'] as Map<String, dynamic>,
  ),
  defense: WaitingRoomPlayerStatValueDto.fromJson(
    json['defense'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$WaitingRoomPlayerStatsDtoToJson(
  WaitingRoomPlayerStatsDto instance,
) => <String, dynamic>{
  'health': instance.health.toJson(),
  'speed': instance.speed.toJson(),
  'attack': instance.attack.toJson(),
  'defense': instance.defense.toJson(),
};

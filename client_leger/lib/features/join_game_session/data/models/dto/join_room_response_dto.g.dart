// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'join_room_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JoinRoomPlayerStatsDto _$JoinRoomPlayerStatsDtoFromJson(
  Map<String, dynamic> json,
) => JoinRoomPlayerStatsDto(
  health: const StatValueConverter().fromJson(json['health']),
  speed: const StatValueConverter().fromJson(json['speed']),
  attack: const StatValueConverter().fromJson(json['attack']),
  defense: const StatValueConverter().fromJson(json['defense']),
);

Map<String, dynamic> _$JoinRoomPlayerStatsDtoToJson(
  JoinRoomPlayerStatsDto instance,
) => <String, dynamic>{
  'health': const StatValueConverter().toJson(instance.health),
  'speed': const StatValueConverter().toJson(instance.speed),
  'attack': const StatValueConverter().toJson(instance.attack),
  'defense': const StatValueConverter().toJson(instance.defense),
};

JoinRoomPlayerDto _$JoinRoomPlayerDtoFromJson(Map<String, dynamic> json) =>
    JoinRoomPlayerDto(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      avatarName: const AvatarNameConverter().fromJson(json['avatar']),
      isVirtual: json['isVirtual'] as bool? ?? false,
      virtualType: _$JsonConverterFromJson<String, VirtualPlayerType>(
        json['profile'],
        const VirtualPlayerTypeConverter().fromJson,
      ),
      stats: JoinRoomPlayerStatsDto.fromJson(
        json['stats'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$JoinRoomPlayerDtoToJson(JoinRoomPlayerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': const AvatarNameConverter().toJson(instance.avatarName),
      'isVirtual': instance.isVirtual,
      'profile': _$JsonConverterToJson<String, VirtualPlayerType>(
        instance.virtualType,
        const VirtualPlayerTypeConverter().toJson,
      ),
      'stats': instance.stats,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

JoinRoomDto _$JoinRoomDtoFromJson(Map<String, dynamic> json) => JoinRoomDto(
  roomId: json['roomId'] as String,
  hostId: json['hostId'] as String,
  players: (json['players'] as List<dynamic>)
      .map((e) => JoinRoomPlayerDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  isLocked: json['isLocked'] as bool,
);

Map<String, dynamic> _$JoinRoomDtoToJson(JoinRoomDto instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'hostId': instance.hostId,
      'players': instance.players.map((e) => e.toJson()).toList(),
      'isLocked': instance.isLocked,
    };

JoinRoomResponseDto _$JoinRoomResponseDtoFromJson(Map<String, dynamic> json) =>
    JoinRoomResponseDto(
      success: json['success'] as bool,
      error: json['error'] as String?,
      room: json['room'] == null
          ? null
          : JoinRoomDto.fromJson(json['room'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$JoinRoomResponseDtoToJson(
  JoinRoomResponseDto instance,
) => <String, dynamic>{
  'success': instance.success,
  'error': instance.error,
  'room': instance.room?.toJson(),
};

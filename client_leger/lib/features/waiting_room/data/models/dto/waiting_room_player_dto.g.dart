// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiting_room_player_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaitingRoomPlayerDto _$WaitingRoomPlayerDtoFromJson(
  Map<String, dynamic> json,
) => WaitingRoomPlayerDto(
  id: json['id'] as String,
  name: json['name'] as String,
  avatar: const SafeAvatarPayloadConverter().fromJson(json['avatar']),
  stats: WaitingRoomPlayerStatsDto.fromJson(
    json['stats'] as Map<String, dynamic>,
  ),
  isVirtual: json['isVirtual'] as bool? ?? false,
  virtualType: json['profile'] == null
      ? VirtualPlayerType.aggressive
      : const VirtualPlayerTypeConverter().fromJson(json['profile'] as String),
  d6Choice: _$JsonConverterFromJson<String, DiceStatChoice>(
    json['d6Choice'],
    const DiceStatChoiceConverter().fromJson,
  ),
  d4Choice: _$JsonConverterFromJson<String, DiceStatChoice>(
    json['d4Choice'],
    const DiceStatChoiceConverter().fromJson,
  ),
  profileAvatarId: json['profileAvatarId'] as String?,
  profileAvatarUrl: json['profileAvatarUrl'] as String?,
  activeBanner: json['activeBanner'] as String?,
);

Map<String, dynamic> _$WaitingRoomPlayerDtoToJson(
  WaitingRoomPlayerDto instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'avatar': const SafeAvatarPayloadConverter().toJson(instance.avatar),
  'isVirtual': instance.isVirtual,
  'profile': const VirtualPlayerTypeConverter().toJson(instance.virtualType),
  'stats': instance.stats,
  'd6Choice': _$JsonConverterToJson<String, DiceStatChoice>(
    instance.d6Choice,
    const DiceStatChoiceConverter().toJson,
  ),
  'd4Choice': _$JsonConverterToJson<String, DiceStatChoice>(
    instance.d4Choice,
    const DiceStatChoiceConverter().toJson,
  ),
  'profileAvatarId': instance.profileAvatarId,
  'profileAvatarUrl': instance.profileAvatarUrl,
  'activeBanner': instance.activeBanner,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

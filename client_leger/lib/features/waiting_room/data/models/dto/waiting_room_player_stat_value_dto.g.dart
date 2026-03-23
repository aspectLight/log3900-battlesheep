// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'waiting_room_player_stat_value_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WaitingRoomPlayerStatValueDto _$WaitingRoomPlayerStatValueDtoFromJson(
  Map<String, dynamic> json,
) => WaitingRoomPlayerStatValueDto(
  value: (json['value'] as num).toInt(),
  maxValue: (json['maxValue'] as num).toInt(),
  description: json['description'] as String,
);

Map<String, dynamic> _$WaitingRoomPlayerStatValueDtoToJson(
  WaitingRoomPlayerStatValueDto instance,
) => <String, dynamic>{
  'value': instance.value,
  'maxValue': instance.maxValue,
  'description': instance.description,
};

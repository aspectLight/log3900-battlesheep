// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_room_created_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameRoomCreatedPayloadDto _$GameRoomCreatedPayloadDtoFromJson(
  Map<String, dynamic> json,
) => GameRoomCreatedPayloadDto(
  roomId: json['roomId'] as String,
  gameId: json['gameId'] as String,
  hostId: json['hostId'] as String,
);

Map<String, dynamic> _$GameRoomCreatedPayloadDtoToJson(
  GameRoomCreatedPayloadDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'gameId': instance.gameId,
  'hostId': instance.hostId,
};

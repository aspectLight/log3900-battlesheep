// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_player_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePlayerPayloadDto _$CreatePlayerPayloadDtoFromJson(
  Map<String, dynamic> json,
) => CreatePlayerPayloadDto(
  roomId: json['roomId'] as String,
  player: WaitingRoomPlayerDto.fromJson(json['player'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreatePlayerPayloadDtoToJson(
  CreatePlayerPayloadDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'player': instance.player.toJson(),
};

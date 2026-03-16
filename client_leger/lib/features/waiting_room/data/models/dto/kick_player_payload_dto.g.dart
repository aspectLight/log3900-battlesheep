// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kick_player_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KickPlayerPayloadDto _$KickPlayerPayloadDtoFromJson(
  Map<String, dynamic> json,
) => KickPlayerPayloadDto(
  roomId: json['roomId'] as String,
  player: WaitingRoomPlayerDto.fromJson(json['player'] as Map<String, dynamic>),
);

Map<String, dynamic> _$KickPlayerPayloadDtoToJson(
  KickPlayerPayloadDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'player': instance.player.toJson(),
};

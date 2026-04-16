// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_waiting_room_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWaitingRoomPayloadDto _$CreateWaitingRoomPayloadDtoFromJson(
  Map<String, dynamic> json,
) => CreateWaitingRoomPayloadDto(
  roomId: json['roomId'] as String,
  gameId: json['gameId'] as String,
  host: WaitingRoomPlayerDto.fromJson(json['host'] as Map<String, dynamic>),
  friendsOnly: json['friendsOnly'] as bool? ?? false,
);

Map<String, dynamic> _$CreateWaitingRoomPayloadDtoToJson(
  CreateWaitingRoomPayloadDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'gameId': instance.gameId,
  'host': instance.host.toJson(),
  'friendsOnly': instance.friendsOnly,
};

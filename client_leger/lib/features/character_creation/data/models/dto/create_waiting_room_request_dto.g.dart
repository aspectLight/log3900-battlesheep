// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_waiting_room_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateWaitingRoomRequestDto _$CreateWaitingRoomRequestDtoFromJson(
  Map<String, dynamic> json,
) => CreateWaitingRoomRequestDto(
  roomId: json['roomId'] as String,
  gameId: json['gameId'] as String,
  host: PlayerPayloadDto.fromJson(json['host'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreateWaitingRoomRequestDtoToJson(
  CreateWaitingRoomRequestDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'gameId': instance.gameId,
  'host': instance.host.toJson(),
};

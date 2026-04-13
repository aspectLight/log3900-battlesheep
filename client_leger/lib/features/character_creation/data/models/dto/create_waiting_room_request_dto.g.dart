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
  entryFee: (json['entryFee'] as num?)?.toInt() ?? 0,
  friendsOnly: json['friendsOnly'] as bool? ?? false,
);

Map<String, dynamic> _$CreateWaitingRoomRequestDtoToJson(
  CreateWaitingRoomRequestDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'gameId': instance.gameId,
  'host': instance.host.toJson(),
  'entryFee': instance.entryFee,
  'friendsOnly': instance.friendsOnly,
};

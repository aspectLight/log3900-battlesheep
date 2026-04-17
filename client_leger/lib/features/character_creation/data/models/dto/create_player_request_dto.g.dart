// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_player_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePlayerRequestDto _$CreatePlayerRequestDtoFromJson(
  Map<String, dynamic> json,
) => CreatePlayerRequestDto(
  roomId: json['roomId'] as String,
  player: PlayerPayloadDto.fromJson(json['player'] as Map<String, dynamic>),
);

Map<String, dynamic> _$CreatePlayerRequestDtoToJson(
  CreatePlayerRequestDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'player': instance.player.toJson(),
};

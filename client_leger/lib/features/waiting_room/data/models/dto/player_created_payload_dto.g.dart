// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_created_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerCreatedPayloadDto _$PlayerCreatedPayloadDtoFromJson(
  Map<String, dynamic> json,
) => PlayerCreatedPayloadDto(
  players: (json['players'] as List<dynamic>)
      .map((e) => WaitingRoomPlayerDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlayerCreatedPayloadDtoToJson(
  PlayerCreatedPayloadDto instance,
) => <String, dynamic>{
  'players': instance.players.map((e) => e.toJson()).toList(),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserve_character_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReserveCharacterRequestDto _$ReserveCharacterRequestDtoFromJson(
  Map<String, dynamic> json,
) => ReserveCharacterRequestDto(
  roomId: json['roomId'] as String,
  chosenAvatar: json['chosenAvatar'] as String,
  playerId: json['playerId'] as String,
);

Map<String, dynamic> _$ReserveCharacterRequestDtoToJson(
  ReserveCharacterRequestDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'chosenAvatar': instance.chosenAvatar,
  'playerId': instance.playerId,
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reserve_character_command_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReserveCharacterCommandDto _$ReserveCharacterCommandDtoFromJson(
  Map<String, dynamic> json,
) => ReserveCharacterCommandDto(
  roomId: json['roomId'] as String,
  chosenCharacter: const ChosenAvatarCharacterConverter().fromJson(
    json['chosenAvatar'] as String,
  ),
  playerId: json['playerId'] as String,
);

Map<String, dynamic> _$ReserveCharacterCommandDtoToJson(
  ReserveCharacterCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'chosenAvatar': const ChosenAvatarCharacterConverter().toJson(
    instance.chosenCharacter,
  ),
  'playerId': instance.playerId,
};

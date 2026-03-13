// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_character_reserved_payload_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateCharacterReservedPayloadDto _$UpdateCharacterReservedPayloadDtoFromJson(
  Map<String, dynamic> json,
) => UpdateCharacterReservedPayloadDto(
  reservedAvatars: (json['reservedAvatars'] as List<dynamic>)
      .map((e) => ReservedCharacterItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UpdateCharacterReservedPayloadDtoToJson(
  UpdateCharacterReservedPayloadDto instance,
) => <String, dynamic>{'reservedAvatars': instance.reservedAvatars};

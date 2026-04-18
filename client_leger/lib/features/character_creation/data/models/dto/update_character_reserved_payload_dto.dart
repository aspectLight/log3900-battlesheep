import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import 'reserved_character_item_dto.dart';

part 'update_character_reserved_payload_dto.g.dart';

@JsonSerializable()
class UpdateCharacterReservedPayloadDto {
  final List<ReservedCharacterItemDto> reservedAvatars;

  const UpdateCharacterReservedPayloadDto({required this.reservedAvatars});

  factory UpdateCharacterReservedPayloadDto.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateCharacterReservedPayloadDtoFromJson(json);

  factory UpdateCharacterReservedPayloadDto.fromObject(Object? data) {
    if (data == null || data is! Map) {
      return const UpdateCharacterReservedPayloadDto(reservedAvatars: []);
    }
    try {
      final json = jsonDecode(jsonEncode(data)) as Map<String, dynamic>;
      return UpdateCharacterReservedPayloadDto.fromJson(json);
    } on Object {
      return const UpdateCharacterReservedPayloadDto(reservedAvatars: []);
    }
  }
}

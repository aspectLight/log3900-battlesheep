import 'package:json_annotation/json_annotation.dart';

import 'reservation_dto.dart';

part 'update_character_reserved_payload_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class UpdateCharacterReservedPayloadDto {
  @JsonKey(name: 'reservedAvatars')
  final List<ReservationDto> reservedCharacters;

  const UpdateCharacterReservedPayloadDto({required this.reservedCharacters});

  factory UpdateCharacterReservedPayloadDto.fromJson(
    Map<String, dynamic> json,
  ) => _$UpdateCharacterReservedPayloadDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateCharacterReservedPayloadDtoToJson(this);
}

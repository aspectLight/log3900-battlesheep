import 'package:json_annotation/json_annotation.dart';

part 'reserve_character_ack_dto.g.dart';

@JsonSerializable()
class ReserveCharacterAckDto {
  final bool success;

  const ReserveCharacterAckDto({required this.success});

  factory ReserveCharacterAckDto.fromJson(Map<String, dynamic> json) =>
      _$ReserveCharacterAckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReserveCharacterAckDtoToJson(this);
}

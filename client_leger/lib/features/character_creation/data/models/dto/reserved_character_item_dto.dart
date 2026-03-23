import 'package:json_annotation/json_annotation.dart';

part 'reserved_character_item_dto.g.dart';

@JsonSerializable()
class ReservedCharacterItemDto {
  final String reservorId;
  final String chosenAvatar;

  const ReservedCharacterItemDto({
    required this.reservorId,
    required this.chosenAvatar,
  });

  factory ReservedCharacterItemDto.fromJson(Map<String, dynamic> json) =>
      _$ReservedCharacterItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservedCharacterItemDtoToJson(this);
}

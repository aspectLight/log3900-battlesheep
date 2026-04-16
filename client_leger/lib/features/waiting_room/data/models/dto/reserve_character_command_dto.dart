import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/converters/character_converters.dart';
import '../../../../../core/enums/character.dart';

part 'reserve_character_command_dto.g.dart';

@JsonSerializable()
class ReserveCharacterCommandDto {
  final String roomId;
  @JsonKey(name: 'chosenAvatar')
  @ChosenAvatarCharacterConverter()
  final Character chosenCharacter;
  final String playerId;
  @JsonKey(defaultValue: false)
  final bool isVirtual;

  const ReserveCharacterCommandDto({
    required this.roomId,
    required this.chosenCharacter,
    required this.playerId,
    this.isVirtual = false,
  });

  factory ReserveCharacterCommandDto.fromJson(Map<String, dynamic> json) =>
      _$ReserveCharacterCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReserveCharacterCommandDtoToJson(this);
}

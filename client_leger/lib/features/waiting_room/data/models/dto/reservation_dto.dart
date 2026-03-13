import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/converters/character_converters.dart';
import '../../../../../core/enums/character.dart';

part 'reservation_dto.g.dart';

@JsonSerializable()
class ReservationDto {
  @JsonKey(name: 'chosenAvatar')
  @ChosenAvatarCharacterConverter()
  final Character character;
  @JsonKey(name: 'reservorId')
  final String playerId;

  const ReservationDto({required this.character, required this.playerId});

  factory ReservationDto.fromJson(Map<String, dynamic> json) =>
      _$ReservationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationDtoToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'reserve_character_request_dto.g.dart';

@JsonSerializable()
class ReserveCharacterRequestDto {
  final String roomId;
  final String chosenAvatar;
  final String playerId;

  const ReserveCharacterRequestDto({
    required this.roomId,
    required this.chosenAvatar,
    required this.playerId,
  });

  factory ReserveCharacterRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ReserveCharacterRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReserveCharacterRequestDtoToJson(this);
}

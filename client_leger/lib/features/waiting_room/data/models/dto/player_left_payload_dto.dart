import 'package:json_annotation/json_annotation.dart';

part 'player_left_payload_dto.g.dart';

@JsonSerializable()
class PlayerLeftPayloadDto {
  final String playerId;

  const PlayerLeftPayloadDto({required this.playerId});

  factory PlayerLeftPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerLeftPayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerLeftPayloadDtoToJson(this);
}

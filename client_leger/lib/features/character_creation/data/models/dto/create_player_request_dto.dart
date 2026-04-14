import 'package:json_annotation/json_annotation.dart';

import 'player_payload_dto.dart';

part 'create_player_request_dto.g.dart';

@JsonSerializable()
class CreatePlayerRequestDto {
  final String roomId;
  final PlayerPayloadDto player;

  const CreatePlayerRequestDto({required this.roomId, required this.player});

  factory CreatePlayerRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePlayerRequestDtoToJson(this);
}

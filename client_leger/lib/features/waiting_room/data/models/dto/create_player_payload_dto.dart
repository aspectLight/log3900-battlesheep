import 'package:json_annotation/json_annotation.dart';

import 'waiting_room_player_dto.dart';

part 'create_player_payload_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class CreatePlayerPayloadDto {
  final String roomId;
  final WaitingRoomPlayerDto player;

  const CreatePlayerPayloadDto({required this.roomId, required this.player});

  factory CreatePlayerPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerPayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePlayerPayloadDtoToJson(this);
}

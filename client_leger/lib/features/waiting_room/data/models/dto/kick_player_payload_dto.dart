import 'package:json_annotation/json_annotation.dart';

import 'waiting_room_player_dto.dart';

part 'kick_player_payload_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class KickPlayerPayloadDto {
  final String roomId;
  final WaitingRoomPlayerDto player;

  const KickPlayerPayloadDto({required this.roomId, required this.player});

  factory KickPlayerPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$KickPlayerPayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$KickPlayerPayloadDtoToJson(this);
}

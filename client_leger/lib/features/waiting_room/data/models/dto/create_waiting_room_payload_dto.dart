import 'package:json_annotation/json_annotation.dart';

import 'waiting_room_player_dto.dart';

part 'create_waiting_room_payload_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateWaitingRoomPayloadDto {
  final String roomId;
  final String gameId;
  final WaitingRoomPlayerDto host;

  const CreateWaitingRoomPayloadDto({
    required this.roomId,
    required this.gameId,
    required this.host,
  });

  factory CreateWaitingRoomPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$CreateWaitingRoomPayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateWaitingRoomPayloadDtoToJson(this);
}

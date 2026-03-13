import 'package:json_annotation/json_annotation.dart';

import 'player_payload_dto.dart';

part 'create_waiting_room_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateWaitingRoomRequestDto {
  const CreateWaitingRoomRequestDto({
    required this.roomId,
    required this.gameId,
    required this.host,
  });

  final String roomId;
  final String gameId;
  final PlayerPayloadDto host;

  factory CreateWaitingRoomRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateWaitingRoomRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateWaitingRoomRequestDtoToJson(this);
}

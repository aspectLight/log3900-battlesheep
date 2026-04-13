import 'package:json_annotation/json_annotation.dart';

import 'player_payload_dto.dart';

part 'create_waiting_room_request_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class CreateWaitingRoomRequestDto {
  const CreateWaitingRoomRequestDto({
    required this.roomId,
    required this.gameId,
    required this.host,
    this.entryFee = 0,
    this.friendsOnly = false,
  });

  final String roomId;
  final String gameId;
  final PlayerPayloadDto host;
  final int entryFee;
  final bool friendsOnly;

  factory CreateWaitingRoomRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateWaitingRoomRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateWaitingRoomRequestDtoToJson(this);
}

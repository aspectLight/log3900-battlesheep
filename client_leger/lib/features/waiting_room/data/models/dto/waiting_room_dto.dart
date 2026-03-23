import 'package:json_annotation/json_annotation.dart';

import 'waiting_room_player_dto.dart';

part 'waiting_room_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class WaitingRoomDto {
  @JsonKey(name: 'roomId')
  final String roomId;
  final String hostId;
  final List<WaitingRoomPlayerDto> players;
  final bool isLocked;

  const WaitingRoomDto({
    required this.roomId,
    required this.hostId,
    required this.players,
    required this.isLocked,
  });

  factory WaitingRoomDto.fromJson(Map<String, dynamic> json) =>
      _$WaitingRoomDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WaitingRoomDtoToJson(this);
}

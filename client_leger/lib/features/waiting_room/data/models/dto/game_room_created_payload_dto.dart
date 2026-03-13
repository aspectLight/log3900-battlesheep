import 'package:json_annotation/json_annotation.dart';

part 'game_room_created_payload_dto.g.dart';

@JsonSerializable()
class GameRoomCreatedPayloadDto {
  const GameRoomCreatedPayloadDto({
    required this.roomId,
    required this.gameId,
    required this.hostId,
  });

  final String roomId;
  final String gameId;
  final String hostId;

  factory GameRoomCreatedPayloadDto.fromJson(Map<String, dynamic> json) =>
      _$GameRoomCreatedPayloadDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameRoomCreatedPayloadDtoToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'waiting_room_command_ack_dto.g.dart';

@JsonSerializable()
class WaitingRoomCommandAckDto {
  const WaitingRoomCommandAckDto({
    required this.success,
    this.error,
  });

  final bool success;
  final String? error;

  factory WaitingRoomCommandAckDto.fromJson(Map<String, dynamic> json) =>
      _$WaitingRoomCommandAckDtoFromJson(json);

  Map<String, dynamic> toJson() => _$WaitingRoomCommandAckDtoToJson(this);
}

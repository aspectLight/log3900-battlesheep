import 'package:json_annotation/json_annotation.dart';

part 'toggle_lock_waiting_room_command_dto.g.dart';

@JsonSerializable()
class ToggleLockWaitingRoomCommandDto {
  final String roomId;

  const ToggleLockWaitingRoomCommandDto({required this.roomId});

  factory ToggleLockWaitingRoomCommandDto.fromJson(Map<String, dynamic> json) =>
      _$ToggleLockWaitingRoomCommandDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ToggleLockWaitingRoomCommandDtoToJson(this);
}

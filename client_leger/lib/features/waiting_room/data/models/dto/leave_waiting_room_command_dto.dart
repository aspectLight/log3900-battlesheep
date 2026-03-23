import 'package:json_annotation/json_annotation.dart';

part 'leave_waiting_room_command_dto.g.dart';

@JsonSerializable()
class LeaveWaitingRoomCommandDto {
  final String roomId;

  const LeaveWaitingRoomCommandDto({required this.roomId});

  factory LeaveWaitingRoomCommandDto.fromJson(Map<String, dynamic> json) =>
      _$LeaveWaitingRoomCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LeaveWaitingRoomCommandDtoToJson(this);
}

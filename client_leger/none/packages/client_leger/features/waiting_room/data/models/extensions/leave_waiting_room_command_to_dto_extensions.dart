import '../../../domain/commands/leave_waiting_room_command.dart';
import '../dto/leave_waiting_room_command_dto.dart';

extension LeaveWaitingRoomCommandToDto on LeaveWaitingRoomCommand {
  LeaveWaitingRoomCommandDto toLeaveWaitingRoomCommandDto() =>
      LeaveWaitingRoomCommandDto(roomId: roomId);
}

import '../../../domain/commands/toggle_lock_waiting_room_command.dart';
import '../dto/toggle_lock_waiting_room_command_dto.dart';

extension ToggleLockWaitingRoomCommandToDto on ToggleLockWaitingRoomCommand {
  ToggleLockWaitingRoomCommandDto toToggleLockWaitingRoomCommandDto() =>
      ToggleLockWaitingRoomCommandDto(roomId: roomId);
}

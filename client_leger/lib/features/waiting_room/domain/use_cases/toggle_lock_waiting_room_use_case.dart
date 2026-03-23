import '../commands/toggle_lock_waiting_room_command.dart';
import '../../data/repositories/waiting_room_room_repository.dart';

class ToggleLockWaitingRoomUseCase {
  ToggleLockWaitingRoomUseCase({
    required WaitingRoomRoomRepository roomRepository,
  }) : _roomRepository = roomRepository;

  final WaitingRoomRoomRepository _roomRepository;

  void execute() {
    final roomId = _roomRepository.state.value.room.roomId;
    _roomRepository.toggleLock(
      ToggleLockWaitingRoomCommand(roomId: roomId),
    );
  }
}

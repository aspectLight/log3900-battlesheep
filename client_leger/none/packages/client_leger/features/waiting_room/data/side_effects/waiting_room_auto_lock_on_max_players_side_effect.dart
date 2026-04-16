import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/typedefs/waiting_room_start_validation_params.dart';
import '../../domain/commands/toggle_lock_waiting_room_command.dart';
import '../../domain/events/room_locked_event.dart';
import '../../core/helpers/waiting_room_start_validation.dart';
import '../repositories/waiting_room_room_repository.dart';
import '../services/waiting_room_socket.dart';

class WaitingRoomAutoLockOnMaxPlayersSideEffect with DisposableSideEffect {
  WaitingRoomAutoLockOnMaxPlayersSideEffect({
    required WaitingRoomSocket waitingRoomSocket,
    required WaitingRoomRoomRepository roomRepository,
    required WaitingRoomStartValidationParams startParams,
  }) : _waitingRoomSocket = waitingRoomSocket,
       _roomRepository = roomRepository,
       _startParams = startParams {
    trackEffect(_autoLockIfNeeded);
  }

  final WaitingRoomSocket _waitingRoomSocket;
  final WaitingRoomRoomRepository _roomRepository;
  final WaitingRoomStartValidationParams _startParams;

  void _autoLockIfNeeded() {
    final room = _roomRepository.state.value.room;
    if (!_roomRepository.isHost) return;
    if (room.isLocked) return;
    if (!isWaitingRoomAtMaxPlayers(room, _startParams)) return;
    _roomRepository.applyRoomLocked(const RoomLockedEvent());
    _waitingRoomSocket.toggleLockWaitingRoom(
      ToggleLockWaitingRoomCommand(roomId: room.roomId),
    );
  }
}

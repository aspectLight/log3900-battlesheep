import '../../../../core/app_transition/app_transition_bus.dart';
import 'package:fpdart/fpdart.dart';
import '../../core/app_events/waiting_room_events.dart';
import '../../core/exceptions/waiting_room_failure.dart';
import '../commands/leave_waiting_room_command.dart';
import '../../data/repositories/waiting_room_room_repository.dart';

class LeaveWaitingRoomUseCase {
  LeaveWaitingRoomUseCase({
    required WaitingRoomRoomRepository roomRepository,
    required AppTransitionEventBus appTransitionEventBus,
  }) : _roomRepository = roomRepository,
       _appTransitionEventBus = appTransitionEventBus;

  final WaitingRoomRoomRepository _roomRepository;
  final AppTransitionEventBus _appTransitionEventBus;

  Future<Either<WaitingRoomFailure, void>> execute() async {
    final roomId = _roomRepository.state.value.room.roomId;
    final result = await _roomRepository.leaveRoom(
      LeaveWaitingRoomCommand(roomId: roomId),
    );
    return result.map((_) {
      _appTransitionEventBus.fire(
        const WaitingRoomExitAppEvent.leaveRequested(),
      );
    });
  }
}

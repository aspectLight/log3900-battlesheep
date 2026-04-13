import '../../data/repositories/waiting_room_room_repository.dart';

class ToggleDropInDropOutUseCase {
  ToggleDropInDropOutUseCase({
    required WaitingRoomRoomRepository roomRepository,
  }) : _roomRepository = roomRepository;

  final WaitingRoomRoomRepository _roomRepository;

  void execute() {
    final roomId = _roomRepository.state.value.room.roomId;
    _roomRepository.toggleDropInDropOut(roomId);
  }
}

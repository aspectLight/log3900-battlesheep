import '../models/waiting_room_player_model.dart';
import '../commands/kick_player_command.dart';
import '../../data/repositories/waiting_room_room_repository.dart';

class KickPlayerUseCase {
  KickPlayerUseCase({
    required WaitingRoomRoomRepository roomRepository,
  }) : _roomRepository = roomRepository;

  final WaitingRoomRoomRepository _roomRepository;

  void execute(WaitingRoomPlayerModel player) {
    final roomId = _roomRepository.state.value.room.roomId;
    _roomRepository.kickPlayer(
      KickPlayerCommand(roomId: roomId, player: player),
    );
  }
}

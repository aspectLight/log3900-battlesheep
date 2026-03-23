import '../../../../core/models/lobby_room_model.dart';

class JoinRoomResult {
  const JoinRoomResult({
    required this.roomCode,
    required this.socketId,
    required this.hostId,
    required this.initialRoom,
  });

  final String roomCode;
  final String socketId;
  final String hostId;
  final LobbyRoomModel initialRoom;
}

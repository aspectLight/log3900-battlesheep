import 'lobby_player_model.dart';

class LobbyRoomModel {
  const LobbyRoomModel({
    required this.roomId,
    required this.hostId,
    required this.players,
    required this.isLocked,
    required this.dropInDropOut,
    this.entryFee = 0,
  });

  final String roomId;
  final String hostId;
  final List<LobbyPlayerModel> players;
  final bool isLocked;
  final bool dropInDropOut;
  final int entryFee;
}

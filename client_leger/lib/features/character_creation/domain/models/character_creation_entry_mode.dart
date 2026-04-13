import '../../../../core/models/lobby_room_model.dart';

sealed class CharacterCreationEntryMode {
  const CharacterCreationEntryMode();
}

class CharacterCreationHostEntryMode extends CharacterCreationEntryMode {
  const CharacterCreationHostEntryMode({
    required this.gameId,
    required this.gameName,
    required this.gameDescription,
    required this.boardSize,
    required this.isCTF,
    this.friendsOnly = false,
  });

  final String gameId;
  final String gameName;
  final String gameDescription;
  final int boardSize;
  final bool isCTF;
  final bool friendsOnly;
}

class CharacterCreationJoinEntryMode extends CharacterCreationEntryMode {
  const CharacterCreationJoinEntryMode({
    required this.hostId,
    required this.initialRoom,
  });

  final String hostId;
  final LobbyRoomModel initialRoom;
}

/// Holds game-room sync data from the join-game-room socket response until the
/// game session scope is ready (so player list payloads are not missed before
/// socket listeners are registered).
class DropInJoinSyncHolder {
  List<dynamic>? playersRaw;
  Map<String, dynamic>? currentBoardRaw;
  String gameRoomHostId = '';
  String? currentPlayerId;
  int? turnTimeRemaining;
  /// `break` = pause entre tours, `play` = compte à rebours du tour actif (cf. événements socket serveur).
  String? turnCountdownPhase;

  void setFromJoinResponse(
    Map<String, dynamic> gameRoom,
    Map<String, dynamic>? currentBoard,
    String? currentPlayerId, {
    int? turnTimeRemaining,
    String? turnCountdownPhase,
  }) {
    playersRaw = gameRoom['players'] as List<dynamic>?;
    currentBoardRaw = currentBoard;
    gameRoomHostId = gameRoom['hostId'] as String? ?? '';
    this.currentPlayerId = currentPlayerId;
    this.turnTimeRemaining = turnTimeRemaining;
    this.turnCountdownPhase = turnCountdownPhase;
  }

  void clear() {
    playersRaw = null;
    currentBoardRaw = null;
    gameRoomHostId = '';
    currentPlayerId = null;
    turnTimeRemaining = null;
    turnCountdownPhase = null;
  }
}

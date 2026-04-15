import '../../../select_game_session/domain/models/game_info_model.dart';

class AvailableRoomModel {
  const AvailableRoomModel({
    required this.roomId,
    required this.playerCount,
    required this.maxPlayers,
    required this.boardSize,
    required this.boardMatrix,
    required this.status,
    required this.isLocked,
    required this.dropInDropOut,
    required this.entryFee,
  });

  final String roomId;
  final int playerCount;
  final int maxPlayers;
  final int boardSize;

  /// Même grille que l’écran « créer une partie » (aperçu plateau).
  final List<List<GameBoardPreviewCell>> boardMatrix;
  final String status;
  final bool isLocked;
  final bool dropInDropOut;
  final int entryFee;

  bool get isPlaying => status == 'playing';

  bool get isJoinable {
    if (playerCount >= maxPlayers) return false;
    if (isPlaying) return dropInDropOut;
    return !isLocked;
  }

  String get fourDigitCode => roomId.replaceFirst('game_', '');
}

class GameInfoUi {
  final String gameName;
  final String gameDescription;
  final int playerCount;
  final String activePlayerName;
  final int boardSize;

  const GameInfoUi({
    required this.gameName,
    required this.gameDescription,
    required this.playerCount,
    required this.activePlayerName,
    required this.boardSize,
  });
}

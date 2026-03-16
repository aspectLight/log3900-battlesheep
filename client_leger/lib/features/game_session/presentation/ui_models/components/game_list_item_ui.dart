class GameListItemUi {
  final String id;
  final String name;
  final String mode;
  final int boardSize;
  final int maxPlayers;
  final int minPlayers;

  const GameListItemUi({
    required this.id,
    required this.name,
    required this.mode,
    required this.boardSize,
    required this.maxPlayers,
    required this.minPlayers,
  });
}

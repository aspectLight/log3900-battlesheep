class PostGameShareSnapshot {
  const PostGameShareSnapshot({
    required this.hasWon,
    required this.deaths,
    required this.combatWinPercent,
    required this.mapTraversalPercent,
  });

  final bool hasWon;
  final int deaths;
  final int combatWinPercent;
  final int mapTraversalPercent;
}

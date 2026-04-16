import '../components/game_player_ui_stat.dart';

class GamePlayerHudUiState {
  final String name;
  final String avatarPath;
  final int movementPoints;
  final int actionPoints;
  final List<GamePlayerUiStat> statRows;
  final String attackDiceAsset;
  final String defenseDiceAsset;

  const GamePlayerHudUiState({
    required this.name,
    required this.avatarPath,
    required this.movementPoints,
    required this.actionPoints,
    required this.statRows,
    required this.attackDiceAsset,
    required this.defenseDiceAsset,
  });
}

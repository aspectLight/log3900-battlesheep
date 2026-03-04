enum GameMode { classique, ctf }

enum GameResult { won, lost, abandoned }

class GameHistoryItem {
  final DateTime startDate;
  final GameMode mode;
  final GameResult result;

  const GameHistoryItem({
    required this.startDate,
    required this.mode,
    required this.result,
  });
}

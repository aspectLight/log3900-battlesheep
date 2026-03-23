import '../../../../../core/enums/game_mode.dart';
import '../../core/enums/game_result.dart';

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

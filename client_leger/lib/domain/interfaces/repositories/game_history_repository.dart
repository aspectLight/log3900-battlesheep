import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failure.dart';
import '../../entities/game_history_item.dart';

abstract class GameHistoryRepository {
  TaskEither<Failure, List<GameHistoryItem>> getGameHistory();
  TaskEither<Failure, String> startGameHistory(String mode);
  TaskEither<Failure, Unit> endGameHistory({
    required String startDate,
    required bool hasWon,
  });
  TaskEither<Failure, Unit> abandonGameHistory(String startDate);
}

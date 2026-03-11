import 'package:fpdart/fpdart.dart';

import '../../../core/exceptions/history_exception.dart';
import '../../../data/models/game_history_item_dto.dart';
import '../../../data/models/logs_history_item_dto.dart';

abstract class HistoryService {
  TaskEither<HistoryException, List<LogsHistoryItemDto>> fetchLoginHistory();
  TaskEither<HistoryException, List<GameHistoryItemDto>> fetchGameHistory();
  TaskEither<HistoryException, String> startGameHistory(String mode);
  TaskEither<HistoryException, Unit> endGameHistory({
    required String startDate,
    required bool hasWon,
  });
  TaskEither<HistoryException, Unit> abandonGameHistory(String startDate);
}

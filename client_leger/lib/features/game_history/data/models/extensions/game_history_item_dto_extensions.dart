import '../../../../../core/enums/game_mode.dart';
import '../../../core/enums/game_result.dart';
import '../../../domain/models/game_history_item.dart';
import '../dto/game_history_item_dto.dart';

extension GameHistoryItemDtoToEntity on GameHistoryItemDto {
  GameHistoryItem toEntity() {
    final modeEnum = mode.toUpperCase() == 'CTF'
        ? GameMode.captureTheFlag
        : GameMode.classic;
    final resultEnum = hasAbandoned
        ? GameResult.abandoned
        : hasWon
            ? GameResult.won
            : GameResult.lost;
    return GameHistoryItem(
      startDate: DateTime.parse(startDate).toLocal(),
      mode: modeEnum,
      result: resultEnum,
    );
  }
}

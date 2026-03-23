import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/game_board_position.dart';
import '../models/game_item.dart';

part 'game_item_commands.freezed.dart';

@freezed
class ItemDroppedCommand with _$ItemDroppedCommand {
  const factory ItemDroppedCommand({
    required String roomId,
    required ItemDropSource source,
    required GameItem item,
    required GameBoardPosition coords,
  }) = _ItemDroppedCommand;
}

@freezed
class ItemCollectedCommand with _$ItemCollectedCommand {
  const factory ItemCollectedCommand({
    required String roomId,
    required String playerId,
    required GameItem item,
    required GameBoardPosition position,
  }) = _ItemCollectedCommand;
}

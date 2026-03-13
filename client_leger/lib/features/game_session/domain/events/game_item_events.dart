import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/game_board_position.dart';
import '../models/game_item.dart';

part 'game_item_events.freezed.dart';

@freezed
class ItemDroppedEvent with _$ItemDroppedEvent {
  const factory ItemDroppedEvent({
    required String roomId,
    required String playerId,
    required GameItem item,
    required GameBoardPosition coords,
  }) = _ItemDroppedEvent;
}

@freezed
class ItemDroppedDisconnectedEvent with _$ItemDroppedDisconnectedEvent {
  const factory ItemDroppedDisconnectedEvent({
    required List<GameItem> items,
    required GameBoardPosition coords,
    required String roomId,
  }) = _ItemDroppedDisconnectedEvent;
}

@freezed
class ItemCollectedEvent with _$ItemCollectedEvent {
  const factory ItemCollectedEvent({
    required String playerId,
    required GameItem item,
  }) = _ItemCollectedEvent;
}

@freezed
class FlagCollectedEvent with _$FlagCollectedEvent {
  const factory FlagCollectedEvent({required String playerId}) =
      _FlagCollectedEvent;
}

@freezed
class PlayerInventorySetEvent with _$PlayerInventorySetEvent {
  const factory PlayerInventorySetEvent({
    required String playerId,
    required List<GameItem> items,
  }) = _PlayerInventorySetEvent;
}

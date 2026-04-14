import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';

import '../models/game_item.dart';

part 'game_inventory_state.freezed.dart';

@freezed
class GameInventoryState with _$GameInventoryState {
  const factory GameInventoryState({
    required Option<String> playerWithFlagId,
    @Default({}) Map<String, List<GameItem>> itemsByPlayerId,
  }) = _GameInventoryState;

  const GameInventoryState._();

  factory GameInventoryState.initial() =>
      const GameInventoryState(playerWithFlagId: Option.none());

  List<GameItem> getItems(String playerId) => itemsByPlayerId[playerId] ?? [];
}

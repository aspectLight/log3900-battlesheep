import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/events/game_events.dart';
import '../../domain/events/game_item_events.dart';
import '../../domain/models/game_item.dart';
import '../../domain/state/game_inventory_state.dart';
import '../reducers/game_inventory_state_reducer.dart';

class GameInventoryRepository {
  final GameInventoryStateReducer _reducer;

  final Signal<GameInventoryState> state = signal(GameInventoryState.initial());

  GameInventoryRepository({required GameInventoryStateReducer reducer})
    : _reducer = reducer;

  void applyItemDropped(ItemDroppedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyItemCollected(ItemCollectedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyItemDroppedDisconnected(ItemDroppedDisconnectedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyFlagCollected(FlagCollectedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyPlayerInventorySet(PlayerInventorySetEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void removePlayerItems(String playerId) {
    final prev = state.value;
    final nextMap = Map<String, List<GameItem>>.from(prev.itemsByPlayerId)
      ..remove(playerId);
    final nextFlag = prev.playerWithFlagId.fold(
      () => const Option<String>.none(),
      (holderId) => holderId == playerId
          ? const Option<String>.none()
          : Option.of(holderId),
    );
    state.value = prev.copyWith(
      itemsByPlayerId: nextMap,
      playerWithFlagId: nextFlag,
    );
  }

  void applyPlayersSpawned(PlayerSpawnedEvent event) {
    final ids = event.players.map((p) => p.id).toSet();
    final pruned = Map<String, List<GameItem>>.from(state.value.itemsByPlayerId)
      ..removeWhere((id, _) => !ids.contains(id));
    state.value = state.value.copyWith(itemsByPlayerId: pruned);
    for (final p in event.players) {
      applyPlayerInventorySet(
        PlayerInventorySetEvent(playerId: p.id, items: p.inventory),
      );
    }
  }
}

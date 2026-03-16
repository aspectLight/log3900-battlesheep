import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/events/game_events.dart';
import '../../domain/events/game_item_events.dart';
import '../../domain/state/game_inventory_state.dart';
import '../reducers/game_inventory_state_reducer.dart';

class GameInventoryRepository {
  final GameInventoryStateReducer _reducer;


  final Signal<GameInventoryState> state = signal(
    GameInventoryState.initial(),
  );

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

  void applyPlayersSpawned(PlayerSpawnedEvent event) {
    for (final p in event.players) {
      applyPlayerInventorySet(
        PlayerInventorySetEvent(playerId: p.id, items: p.inventory),
      );
    }
  }
}

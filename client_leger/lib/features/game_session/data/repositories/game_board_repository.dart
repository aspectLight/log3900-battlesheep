import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/commands/game_door_commands.dart';
import '../../domain/events/game_events.dart';
import '../../domain/events/game_item_events.dart';
import '../../domain/events/game_movement_events.dart';
import '../../domain/events/game_environment_events.dart';
import '../../domain/models/game_board_position.dart';
import '../../domain/models/game_item.dart';
import '../../domain/state/game_board_state.dart';
import '../reducers/game_board_state_reducer.dart';
import '../services/game_board_socket.dart';

class GameBoardRepository {
  final GameBoardStateReducer _reducer;
  final GameBoardSocket _boardSocket;

  late final Signal<GameBoardState> state;

  GameBoardRepository({
    required GameBoardState initialState,
    required GameBoardStateReducer reducer,
    required GameBoardSocket boardSocket,
  }) : _reducer = reducer,
       _boardSocket = boardSocket {
    state = signal(initialState);
  }

  void toggleDoor(ToggleDoorCommand command) {
    _boardSocket.toggleDoor(command);
  }

  void applyPlayersSpawned(PlayerSpawnedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyDoorToggled(DoorToggledEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyPlayerMoved(PlayerMovedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyPlayerTeleported(PlayerTeleportedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyMovementSync(SynchronizeMovementEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyMovementStep(PlayerMovementStepEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applySpawnPointCleared(SpawnPointClearedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void setReachableCells(Set<GameBoardPosition> cells) {
    state.value = state.value.copyWith(reachableCellCoords: cells);
  }

  void clearReachablePaths() {
    state.value = state.value.copyWith(
      reachableCellCoords: const {},
      reachablePathsByDestination: const {},
    );
  }

  void setReachablePathsFromResponse(List<ReachablePath> paths) {
    if (paths.isEmpty) {
      clearReachablePaths();
      return;
    }
    final cells = Set<GameBoardPosition>.from(paths.map((e) => e.from));
    final byDest = Map<GameBoardPosition, List<GameBoardPosition>>.fromEntries(
      paths.map((e) => MapEntry(e.from, e.path)),
    );
    state.value = state.value.copyWith(
      reachableCellCoords: cells,
      reachablePathsByDestination: byDest,
    );
  }

  void setSelectedPath(List<GameBoardPosition> path) {
    state.value = state.value.copyWith(selectedPathCoords: path);
  }

  void setPendingItemPickup(Option<PendingItemPickup> pickup) {
    state.value = state.value.copyWith(pendingItemPickup: pickup);
  }

  void clearPendingItemPickup() {
    state.value = state.value.copyWith(pendingItemPickup: const Option.none());
  }

  void clearPendingItemPickupIfPlayer(String playerId) {
    final current = state.value;
    state.value = current.copyWith(
      pendingItemPickup: current.pendingItemPickup.filter(
        (p) => p.playerId != playerId,
      ),
    );
  }

  void applyItemDropped(ItemDroppedEvent event) {
    final current = state.value;
    if (!current.board.isInBounds(event.coords.x, event.coords.y)) return;
    final nextItems = Map<GameBoardPosition, GameItem>.from(current.items)
      ..[event.coords] = event.item;
    state.value = current.copyWith(items: nextItems);
  }

  void applyIlluminationUpdate(BoardIlluminationUpdatedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyItemCollected(ItemCollectedEvent event) {
    final pos = event.position;
    if (pos == null) return;
    final current = state.value;
    if (!current.board.isInBounds(pos.x, pos.y)) return;
    if (!current.items.containsKey(pos)) return;
    final nextItems = Map<GameBoardPosition, GameItem>.from(current.items)
      ..remove(pos);
    state.value = current.copyWith(items: nextItems);
  }
}

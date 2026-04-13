import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/item_type.dart';
import '../../domain/models/tile.dart';
import '../../domain/models/game_board_position.dart';
import '../../domain/models/game_item.dart';
import '../../domain/events/game_movement_events.dart';
import '../../domain/state/game_board_state.dart';
import '../../domain/events/game_events.dart';

class GameBoardStateReducer {
  GameBoardState reduce(GameBoardState previous, Object event) {
    if (event is PlayerSpawnedEvent) {
      return _reducePlayerSpawned(previous, event);
    }
    if (event is DoorToggledEvent) {
      return _reduceDoorToggled(previous, event);
    }
    if (event is PlayerMovedEvent) {
      return _reducePlayerMoved(previous, event);
    }
    if (event is PlayerMovementStepEvent) {
      return _reducePlayerMovementStep(previous, event);
    }
    if (event is PlayerTeleportedEvent) {
      return _reducePlayerTeleported(previous, event);
    }
    if (event is SynchronizeMovementEvent) {
      return _reduceSynchronizeMovement(previous, event);
    }
    if (event is SpawnPointClearedEvent) {
      return _reduceSpawnPointCleared(previous, event);
    }
    return previous;
  }

  GameBoardState _reducePlayerSpawned(
    GameBoardState previous,
    PlayerSpawnedEvent event,
  ) {
    final board = previous.board;
    final nextPositions = <String, GameBoardPosition>{};
    for (final player in event.players) {
      final pos = player.currentBoardPosition;
      if (!board.isInBounds(pos.x, pos.y)) continue;
      nextPositions[player.id] = pos;
    }
    final occupiedSpawnPositions =
        Set<GameBoardPosition>.from(nextPositions.values);
    final nextItems = Map<GameBoardPosition, GameItem>.from(previous.items);
    for (final entry in previous.items.entries) {
      if (entry.value.type == ItemType.spawnPoint &&
          !occupiedSpawnPositions.contains(entry.key)) {
        nextItems.remove(entry.key);
      }
    }
    return previous.copyWith(
      playerPositions: nextPositions,
      items: nextItems,
    );
  }

  GameBoardState _reduceDoorToggled(
    GameBoardState previous,
    DoorToggledEvent event,
  ) {
    final board = previous.board;
    if (!board.isInBounds(event.x, event.y)) {
      return previous;
    }
    final matrix = board.matrix.map((row) => [...row]).toList();
    final cell = matrix[event.x][event.y];
    final tile = cell.tile;
    if (tile is! DoorTile) return previous;
    matrix[event.x][event.y] = cell.copyWith(tile: tile.toggle());
    return previous.copyWith(board: board.copyWith(matrix: matrix));
  }

  GameBoardState _reducePlayerMoved(
    GameBoardState previous,
    PlayerMovedEvent event,
  ) {
    if (event.selectedPath.isEmpty) {
      return previous.copyWith(
        selectedPathCoords: const [],
        pendingItemPickup: const Option.none(),
      );
    }
    final board = previous.board;
    final dest = event.selectedPath.last;
    if (!board.isInBounds(dest.x, dest.y)) {
      return previous.copyWith(
        selectedPathCoords: const [],
        pendingItemPickup: const Option.none(),
      );
    }
    final nextPositions = Map<String, GameBoardPosition>.from(
      previous.playerPositions,
    );
    nextPositions.remove(event.playerId);
    nextPositions[event.playerId] = dest;
    final cellItem = previous.items[dest];
    if (cellItem == null) {
      return previous.copyWith(
        selectedPathCoords: const [],
        pendingItemPickup: const Option.none(),
        playerPositions: nextPositions,
      );
    }
    if (cellItem.type == ItemType.spawnPoint) {
      return previous.copyWith(
        selectedPathCoords: const [],
        pendingItemPickup: const Option.none(),
        playerPositions: nextPositions,
      );
    }
    final nextItems = Map<GameBoardPosition, GameItem>.from(previous.items)
      ..remove(dest);
    return previous.copyWith(
      selectedPathCoords: const [],
      pendingItemPickup: Option.of(PendingItemPickup(
        playerId: event.playerId,
        item: GameItem(type: cellItem.type),
        cellCoords: dest,
      )),
      playerPositions: nextPositions,
      items: nextItems,
    );
  }

  GameBoardState _reducePlayerMovementStep(
    GameBoardState previous,
    PlayerMovementStepEvent event,
  ) {
    final board = previous.board;
    final dest = event.destination;
    if (!board.isInBounds(dest.x, dest.y)) {
      return previous;
    }
    final nextPositions = Map<String, GameBoardPosition>.from(
      previous.playerPositions,
    );
    nextPositions[event.playerId] = dest;
    return previous.copyWith(playerPositions: nextPositions);
  }

  GameBoardState _reducePlayerTeleported(
    GameBoardState previous,
    PlayerTeleportedEvent event,
  ) {
    final board = previous.board;
    final dest = event.destination;
    if (!board.isInBounds(dest.x, dest.y)) {
      return previous.copyWith(selectedPathCoords: [dest]);
    }
    final nextPositions = Map<String, GameBoardPosition>.from(
      previous.playerPositions,
    );
    nextPositions[event.playerId] = dest;
    return previous.copyWith(
      playerPositions: nextPositions,
      selectedPathCoords: [dest],
    );
  }

  GameBoardState _reduceSynchronizeMovement(
    GameBoardState previous,
    SynchronizeMovementEvent event,
  ) {
    final board = previous.board;
    final dest = event.destination;
    if (!board.isInBounds(dest.x, dest.y)) {
      return previous.copyWith(selectedPathCoords: [dest]);
    }
    final nextPositions = Map<String, GameBoardPosition>.from(
      previous.playerPositions,
    );
    nextPositions[event.playerId] = dest;
    return previous.copyWith(
      playerPositions: nextPositions,
      selectedPathCoords: [dest],
    );
  }

  GameBoardState _reduceSpawnPointCleared(
    GameBoardState previous,
    SpawnPointClearedEvent event,
  ) {
    final board = previous.board;
    final pos = event.position;
    if (!board.isInBounds(pos.x, pos.y)) return previous;
    final cellItem = previous.items[pos];
    if (cellItem == null || cellItem.type != ItemType.spawnPoint) {
      return previous;
    }
    final nextItems = Map<GameBoardPosition, GameItem>.from(previous.items);
    nextItems.remove(pos);
    return previous.copyWith(items: nextItems);
  }
}

import 'package:fpdart/fpdart.dart';

import '../../core/enums/board_character.dart';
import '../../core/enums/stat_type.dart';
import '../../presentation/mappers/path_display_mapper.dart';
import '../../domain/events/game_movement_events.dart';
import '../../domain/events/game_events.dart';
import '../../domain/events/game_item_events.dart';
import '../../domain/models/game_item.dart';
import '../../domain/state/game_player_state.dart';

class GamePlayerStateReducer {
  GamePlayerState reduce(GamePlayerState previous, Object event) {
    if (event is PlayerSpawnedEvent) {
      return _reducePlayerSpawned(previous, event);
    }
    if (event is PlayerAbandonedEvent) {
      return _reducePlayerAbandoned(previous, event);
    }
    if (event is CurrentPlayerChangedEvent) {
      return _reduceCurrentPlayerChanged(previous, event);
    }
    if (event is UpdateScoreEvent) {
      return _reduceUpdateScore(previous, event);
    }
    if (event is PlayerMovedEvent) {
      return _reducePlayerMoved(previous, event);
    }
    if (event is VirtualPlayerMovedEvent) {
      return _reduceVirtualPlayerMoved(previous, event);
    }
    if (event is TurnStartingPlayerPointsEvent) {
      return _reduceTurnStartingPlayerPoints(previous, event);
    }
    if (event is PlayerHealthUpdatedEvent) {
      return _reducePlayerHealthUpdated(previous, event);
    }
    if (event is PlayerMovementStepEvent) {
      return _reducePlayerMovementStep(previous, event);
    }
    if (event is PlayerIdleResetEvent) {
      return _reducePlayerIdleReset(previous, event);
    }
    if (event is ItemCollectedEvent) {
      return _reduceItemCollected(previous, event);
    }
    if (event is ItemDroppedEvent) {
      return _reduceItemDropped(previous, event);
    }
    if (event is ItemDroppedDisconnectedEvent) {
      return _reduceItemDroppedDisconnected(previous, event);
    }
    return previous;
  }

  GamePlayerState _reducePlayerSpawned(
    GamePlayerState previous,
    PlayerSpawnedEvent event,
  ) {
    final players = event.players.map(GamePlayer.fromSpawned).toList();
    final playerIds = players.map((p) => p.id).toSet();
    final prunedDisconnected =
        previous.disconnectedPlayerIds.where(playerIds.contains).toList();
    return previous.copyWith(
      players: players,
      disconnectedPlayerIds: prunedDisconnected,
    );
  }

  GamePlayerState _reducePlayerAbandoned(
    GamePlayerState previous,
    PlayerAbandonedEvent event,
  ) {
    final idx = previous.indexOf(event.playerId);
    if (idx < 0) return previous;
    final players = List<GamePlayer>.from(previous.players)..removeAt(idx);
    final disconnected = [
      for (final id in previous.disconnectedPlayerIds)
        if (id != event.playerId) id,
    ];
    final wins = Map<String, int>.from(previous.winsByPlayerId)
      ..remove(event.playerId);
    return previous.copyWith(
      players: players,
      disconnectedPlayerIds: disconnected,
      winsByPlayerId: wins,
    );
  }

  GamePlayerState _reduceCurrentPlayerChanged(
    GamePlayerState previous,
    CurrentPlayerChangedEvent event,
  ) {
    return previous.copyWith(activePlayerId: Option.of(event.playerId));
  }

  GamePlayerState _reduceUpdateScore(
    GamePlayerState previous,
    UpdateScoreEvent event,
  ) {
    final wins = Map<String, int>.from(previous.winsByPlayerId);
    wins[event.winnerId] = (wins[event.winnerId] ?? 0) + 1;
    return previous.copyWith(winsByPlayerId: wins);
  }

  GamePlayerState _reducePlayerMoved(
    GamePlayerState previous,
    PlayerMovedEvent event,
  ) {
    final idx = previous.indexOf(event.playerId);
    if (idx < 0) return previous;
    final player = previous.players[idx];
    final orientation = orientationFromPath(event.selectedPath);
    final updated = player.copyWith(
      movementPoints: event.movementPoints,
      orientation: orientation,
      state: BoardCharacterState.moving,
    );
    final players = List.of(previous.players)..[idx] = updated;
    return previous.copyWith(players: players);
  }

  GamePlayerState _reduceVirtualPlayerMoved(
    GamePlayerState previous,
    VirtualPlayerMovedEvent event,
  ) {
    final idx = previous.indexOf(event.playerId);
    if (idx < 0) return previous;
    final player = previous.players[idx];
    final orientation = orientationFromPath(event.path);
    final updated = player.copyWith(
      movementPoints: event.remainingMovementPoints,
      orientation: orientation,
      state: BoardCharacterState.moving,
    );
    final players = List.of(previous.players)..[idx] = updated;
    return previous.copyWith(players: players);
  }

  GamePlayerState _reduceTurnStartingPlayerPoints(
    GamePlayerState previous,
    TurnStartingPlayerPointsEvent event,
  ) {
    final idx = previous.indexOf(event.nextPlayerId);
    if (idx < 0) return previous;
    final player = previous.players[idx];
    final updated = player.copyWith(
      movementPoints: event.movementPoints,
      actionPoints: event.actionPoints,
      state: BoardCharacterState.idle,
    );
    final players = List.of(previous.players)..[idx] = updated;
    return previous.copyWith(players: players);
  }

  GamePlayerState _reducePlayerHealthUpdated(
    GamePlayerState previous,
    PlayerHealthUpdatedEvent event,
  ) {
    final idx = previous.indexOf(event.playerId);
    if (idx < 0) return previous;
    final player = previous.players[idx];
    final newStats = Map<StatType, int>.from(player.stats)
      ..[StatType.health] = event.healthPoints;
    var updated = player.copyWith(stats: newStats);
    updated = updated.withReevaluatedPropaganda();
    final players = List.of(previous.players)..[idx] = updated;
    return previous.copyWith(players: players);
  }

  GamePlayerState _reduceItemCollected(
    GamePlayerState previous,
    ItemCollectedEvent event,
  ) {
    final idx = previous.indexOf(event.playerId);
    if (idx < 0) return previous;
    final player = previous.players[idx];
    final updated = player.withItemCollected(event.item);
    final players = List.of(previous.players)..[idx] = updated;
    return previous.copyWith(players: players);
  }

  GamePlayerState _reduceItemDropped(
    GamePlayerState previous,
    ItemDroppedEvent event,
  ) {
    final playerId = event.playerId;
    if (playerId == null) return previous;
    final idx = previous.indexOf(playerId);
    if (idx < 0) return previous;
    final player = previous.players[idx];
    final updated = player.withItemDropped(event.item);
    final players = List.of(previous.players)..[idx] = updated;
    return previous.copyWith(players: players);
  }

  GamePlayerState _reduceItemDroppedDisconnected(
    GamePlayerState previous,
    ItemDroppedDisconnectedEvent event,
  ) {
    final droppedTypes = event.items.map((i) => i.type).toList()..sort();
    for (var i = 0; i < previous.players.length; i++) {
      final inv = previous.players[i].inventory;
      final invTypes = inv
          .whereType<GameItem>()
          .map((e) => e.type)
          .toList()
        ..sort();
      if (invTypes.length != droppedTypes.length) continue;
      var match = true;
      for (var j = 0; j < invTypes.length; j++) {
        if (invTypes[j] != droppedTypes[j]) {
          match = false;
          break;
        }
      }
      if (!match) continue;
      final player = previous.players[i];
      final updated = player.withDisconnectedDrop();
      final players = List.of(previous.players)..[i] = updated;
      return previous.copyWith(players: players);
    }
    return previous;
  }


  GamePlayerState _reducePlayerMovementStep(
    GamePlayerState previous,
    PlayerMovementStepEvent event,
  ) {
    final idx = previous.indexOf(event.playerId);
    if (idx < 0) return previous;
    final player = previous.players[idx];
    final updated = player.copyWith(
      orientation: event.orientation,
      state: BoardCharacterState.moving,
    );
    final players = List.of(previous.players)..[idx] = updated;
    return previous.copyWith(players: players);
  }

  GamePlayerState _reducePlayerIdleReset(
    GamePlayerState previous,
    PlayerIdleResetEvent event,
  ) {
    final idx = previous.indexOf(event.playerId);
    if (idx < 0) return previous;
    final player = previous.players[idx];
    final updated = player.copyWith(state: BoardCharacterState.idle);
    final players = List.of(previous.players)..[idx] = updated;
    return previous.copyWith(players: players);
  }
}

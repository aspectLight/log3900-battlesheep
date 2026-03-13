import 'package:event_bus/event_bus.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/events/game_item_events.dart';
import '../../domain/events/game_movement_events.dart';
import '../../domain/models/game_board_position.dart';
import '../../domain/models/game_item.dart';

class GameSessionEventBus {
  GameSessionEventBus(EventBus bus) : _bus = bus;

  final EventBus _bus;

  void fire<T>(T event) {
    _bus.fire(event);
  }

  Stream<T> on<T>() => _bus.on<T>();
}

class GameSessionScopeReady {
  final String roomId;
  final bool isHost;

  const GameSessionScopeReady({
    required this.roomId,
    required this.isHost,
  });
}

class GameSessionCanceled {
  const GameSessionCanceled();
}

class GameSessionAbandoned {
  const GameSessionAbandoned();
}

class PlayerAbandonedWithSpawnPoint {
  final String playerId;
  final Option<GameBoardPosition> spawnPoint;

  const PlayerAbandonedWithSpawnPoint({
    required this.playerId,
    required this.spawnPoint,
  });
}

class GameSessionFinishedEvent {
  final String winnerId;
  final String roomId;
  final bool isCTF;

  const GameSessionFinishedEvent({
    required this.winnerId,
    required this.roomId,
    required this.isCTF,
  });
}

class CombatStarted {
  final String attackerId;
  final String defenderId;

  const CombatStarted({
    required this.attackerId,
    required this.defenderId,
  });
}

class GameCombatEnded {
  final String winnerId;
  final String loserId;
  final bool isByFlight;

  const GameCombatEnded({
    required this.winnerId,
    required this.loserId,
    required this.isByFlight,
  });
}

class CombatHealthUpdated {
  final String playerId;
  final int healthPoints;

  const CombatHealthUpdated({
    required this.playerId,
    required this.healthPoints,
  });
}

class GameItemDroppedDisconnected {
  final ItemDroppedDisconnectedEvent event;

  const GameItemDroppedDisconnected(this.event);
}

class VirtualPlayerMoved {
  final VirtualPlayerMovedEvent event;

  const VirtualPlayerMoved(this.event);
}

class VirtualPlayerMoveCompleted {
  final VirtualPlayerMovedEvent event;
  final Option<GameBoardPosition> destinationPosition;
  final Option<GameItem> destinationItem;

  const VirtualPlayerMoveCompleted({
    required this.event,
    required this.destinationPosition,
    required this.destinationItem,
  });
}

class PlayerMoveCompleted {
  final PlayerMovedEvent event;

  const PlayerMoveCompleted(this.event);
}

class PlayerMoveAnimationCompleted {
  final PlayerMovedEvent event;
  final String playerId;

  const PlayerMoveAnimationCompleted({
    required this.event,
    required this.playerId,
  });
}

class PendingItemPickupReadyEvent {
  final PendingItemPickup pending;

  const PendingItemPickupReadyEvent(this.pending);
}

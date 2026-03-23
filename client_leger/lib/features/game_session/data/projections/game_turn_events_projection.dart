import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../../data/services/game_events_socket.dart';
import '../../domain/events/game_events.dart';

class GameTurnEventsProjection implements EventProjection {
  final GameEventsSocket _eventsSocket;
  final GameTurnRepository _turnRepository;
  final GamePlayerRepository _playerRepository;
  final GameSessionEventBus _gameSessionEventBus;

  GameTurnEventsProjection({
    required GameEventsSocket eventsSocket,
    required GameTurnRepository turnRepository,
    required GamePlayerRepository playerRepository,
    required GameSessionEventBus gameSessionEventBus,
  }) : _eventsSocket = eventsSocket,
       _turnRepository = turnRepository,
       _playerRepository = playerRepository,
       _gameSessionEventBus = gameSessionEventBus;

  @override
  List<StreamSubscription> subscribe() => [
    _eventsSocket.turnStartingStream.listen(_onTurnStarting),
    _eventsSocket.updateCountdownStream.listen(
      _turnRepository.applyGameCountdown,
    ),
    _eventsSocket.updateStartingCountdownStream.listen(
      _turnRepository.applyStartingCountdown,
    ),
  ];

  void _onTurnStarting(TurnStartingEvent event) {
    _turnRepository.applyTurnStarting(event);
    _playerRepository.applyCurrentPlayerChanged(
      CurrentPlayerChangedEvent(playerId: event.nextPlayerId),
    );
    if (event.nextPlayerId.isNotEmpty) {
      _playerRepository.applyTurnStartingPlayerPoints(
        TurnStartingPlayerPointsEvent(
          nextPlayerId: event.nextPlayerId,
          movementPoints: event.nextPlayerMovementPoints,
          // Use server-provided action points so the HUD doesn't go stale if
          // rules differ by mode/items/debug or evolve server-side.
          actionPoints: event.nextPlayerActionPoints,
        ),
      );
    }
    _gameSessionEventBus.fire(event);
  }
}

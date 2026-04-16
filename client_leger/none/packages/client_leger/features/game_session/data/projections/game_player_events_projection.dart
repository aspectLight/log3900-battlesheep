import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/services/game_events_socket.dart';
import '../../domain/events/game_events.dart';

class GamePlayerEventsProjection implements EventProjection {
  final GameEventsSocket _eventsSocket;
  final GamePlayerRepository _playerRepository;
  final GameSessionEventBus _gameSessionEventBus;

  GamePlayerEventsProjection({
    required GameEventsSocket eventsSocket,
    required GamePlayerRepository playerRepository,
    required GameSessionEventBus gameSessionEventBus,
  }) : _eventsSocket = eventsSocket,
       _playerRepository = playerRepository,
       _gameSessionEventBus = gameSessionEventBus;

  @override
  List<StreamSubscription> subscribe() => [
    _eventsSocket.playerAbandonedStream.listen(_onPlayerAbandoned),
    _eventsSocket.updateScoreStream.listen(_playerRepository.applyScoreUpdated),
  ];

  void _onPlayerAbandoned(PlayerAbandonedEvent event) {
    final spawnPoint = _playerRepository.state.value.spawnPointOfAbandoned(
      event.playerId,
    );
    _playerRepository.applyPlayerAbandoned(event);
    _gameSessionEventBus.fire(
      PlayerAbandonedWithSpawnPoint(
        playerId: event.playerId,
        spawnPoint: spawnPoint,
      ),
    );
  }
}

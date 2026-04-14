import 'dart:async';

import '../../domain/events/game_events.dart';
import '../../domain/state/game_session_state.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../../../core/interfaces/event_projection.dart';
import '../repositories/game_metadata_repository.dart';
import '../services/game_events_socket.dart';

class GameSessionEventsProjection implements EventProjection {
  final GameEventsSocket _eventsSocket;
  final GameMetadataRepository _sessionRepository;
  final GameSessionEventBus _gameSessionEventBus;

  GameSessionEventsProjection({
    required GameEventsSocket eventsSocket,
    required GameMetadataRepository sessionRepository,
    required GameSessionEventBus gameSessionEventBus,
  }) : _eventsSocket = eventsSocket,
       _sessionRepository = sessionRepository,
       _gameSessionEventBus = gameSessionEventBus;

  @override
  List<StreamSubscription> subscribe() => [
    _eventsSocket.gameCanceledStream.listen(_onGameCanceled),
    _eventsSocket.gameAbandonedStream.listen(_onGameAbandoned),
    _eventsSocket.finishGameStream.listen(_onFinishGame),
    _eventsSocket.organizatorChangedStream.listen(
      _sessionRepository.applyOrganizatorChanged,
    ),
  ];

  void _onGameCanceled(GameCanceledEvent event) {
    _gameSessionEventBus.fire(GameSessionCanceled(playerId: event.playerId));
  }

  void _onGameAbandoned(GameAbandonedEvent _) {
    _gameSessionEventBus.fire(const GameSessionAbandoned());
  }

  void _onFinishGame(FinishGameEvent event) {
    final current = _sessionRepository.state.value;
    _sessionRepository.applyFinishGame(event);
    if (current is GameSessionActive) {
      _gameSessionEventBus.fire(
        GameSessionFinishedEvent(
          winnerId: event.winnerId,
          roomId: current.roomId,
          isCTF: current.isCTF,
        ),
      );
    }
  }
}

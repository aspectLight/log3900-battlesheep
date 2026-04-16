import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../services/game_events_socket.dart';

class GameSessionPlayGameSideEffect with DisposableSideEffect {
  GameSessionPlayGameSideEffect({
    required GameSessionEventBus gameSessionEventBus,
    required GameEventsSocket gameEventsSocket,
  }) : _gameSessionEventBus = gameSessionEventBus,
       _gameEventsSocket = gameEventsSocket {
    trackSubscription(
      _gameSessionEventBus.on<GameSessionScopeReady>().listen(_onScopeReady),
    );
  }

  final GameSessionEventBus _gameSessionEventBus;
  final GameEventsSocket _gameEventsSocket;

  void _onScopeReady(GameSessionScopeReady event) {
    if (event.isHost) {
      _gameEventsSocket.emitPlayGame(event.roomId);
    }
  }
}

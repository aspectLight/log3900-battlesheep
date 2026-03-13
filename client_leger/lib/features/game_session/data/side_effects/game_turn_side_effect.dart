import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../data/repositories/game_turn_repository.dart';
import '../../data/services/game_events_socket.dart';
import '../../domain/events/game_events.dart';

class GameTurnSideEffect with DisposableSideEffect {
  final String _socketId;
  final GameTurnRepository _turnRepository;
  final GameEventsSocket _eventsSocket;
  String _currentTurnPlayerId = '';

  GameTurnSideEffect({
    required String socketId,
    required GameTurnRepository turnRepository,
    required GameEventsSocket eventsSocket,
  }) : _socketId = socketId,
       _turnRepository = turnRepository,
       _eventsSocket = eventsSocket {
    trackSubscription(
      _eventsSocket.turnStartingStream.listen(_onTurnStarting),
    );
    trackSubscription(
      _eventsSocket.updateStartingCountdownStream.listen(_onStartingCountdown),
    );
  }

  void _onTurnStarting(TurnStartingEvent event) {
    _currentTurnPlayerId = event.nextPlayerId;
  }

  void _onStartingCountdown(UpdateStartingCountdownEvent event) {
    if (event.countdown != 0) return;
    if (_currentTurnPlayerId != _socketId) return;
    _turnRepository.setCanForwardTurn(value: true);
  }
}

import '../../core/enums/board_interaction_mode.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../domain/events/game_events.dart';
import '../repositories/game_board_interaction_repository.dart';
import '../services/game_events_socket.dart';

class GameTurnAutoSelectionSideEffect with DisposableSideEffect {
  final String _socketId;
  final GameBoardInteractionRepository _interactionRepository;
  final GameEventsSocket _eventsSocket;

  GameTurnAutoSelectionSideEffect({
    required String socketId,
    required GameEventsSocket eventsSocket,
    required GameBoardInteractionRepository interactionRepository,
  }) : _socketId = socketId,
       _interactionRepository = interactionRepository,
       _eventsSocket = eventsSocket {
    trackSubscription(
      _eventsSocket.turnStartingStream.listen(_onTurnStarting),
    );
  }

  void _onTurnStarting(TurnStartingEvent event) {
    if (event.nextPlayerId != _socketId) return;
    if (_interactionRepository.state.value != BoardInteractionMode.idle) return;
    _interactionRepository.enterSelectionMode();
  }
}

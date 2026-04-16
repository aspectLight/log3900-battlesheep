import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../domain/events/game_movement_events.dart';
import '../repositories/game_board_interaction_repository.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_player_repository.dart';

class GamePlayerMovementAnimationCompletedSideEffect with DisposableSideEffect {
  final String _socketId;
  final GameSessionEventBus _gameSessionEventBus;
  final GameBoardRepository _boardRepository;
  final GamePlayerRepository _playerRepository;
  final GameBoardInteractionRepository _interactionRepository;

  GamePlayerMovementAnimationCompletedSideEffect({
    required String socketId,
    required GameSessionEventBus gameSessionEventBus,
    required GameBoardRepository boardRepository,
    required GamePlayerRepository playerRepository,
    required GameBoardInteractionRepository interactionRepository,
  }) : _socketId = socketId,
       _gameSessionEventBus = gameSessionEventBus,
       _boardRepository = boardRepository,
       _playerRepository = playerRepository,
       _interactionRepository = interactionRepository {
    trackSubscription(
      _gameSessionEventBus.on<PlayerMoveAnimationCompleted>().listen(
        _onPlayerMoveAnimationCompleted,
      ),
    );
  }

  void _onPlayerMoveAnimationCompleted(PlayerMoveAnimationCompleted ev) {
    _boardRepository.applyPlayerMoved(ev.event);
    _playerRepository.applyPlayerIdleReset(
      PlayerIdleResetEvent(playerId: ev.playerId),
    );
    if (ev.playerId == _socketId) {
      _interactionRepository.enterSelectionMode();
    } else {
      _interactionRepository.leaveInteraction();
    }
    _boardRepository.state.value.pendingItemPickup.whenPresent((pending) {
      if (pending.playerId == _socketId) {
        _gameSessionEventBus.fire(PendingItemPickupReadyEvent(pending));
      }
    });
  }
}

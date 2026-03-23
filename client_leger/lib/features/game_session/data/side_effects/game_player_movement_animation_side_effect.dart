import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/constants/game_rules_constants.dart';
import '../../core/enums/board_interaction_mode.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../domain/events/game_movement_events.dart';
import '../../domain/models/game_board_position.dart';
import '../../presentation/mappers/path_display_mapper.dart';
import '../repositories/game_board_interaction_repository.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_player_repository.dart';

class GamePlayerMovementAnimationSideEffect with DisposableSideEffect {
  final GameSessionEventBus _gameSessionEventBus;
  final GameBoardRepository _boardRepository;
  final GamePlayerRepository _playerRepository;
  final GameBoardInteractionRepository _interactionRepository;

  GamePlayerMovementAnimationSideEffect({
    required GameSessionEventBus gameSessionEventBus,
    required GameBoardRepository boardRepository,
    required GamePlayerRepository playerRepository,
    required GameBoardInteractionRepository interactionRepository,
  }) : _gameSessionEventBus = gameSessionEventBus,
       _boardRepository = boardRepository,
       _playerRepository = playerRepository,
       _interactionRepository = interactionRepository {
    trackSubscription(
      _gameSessionEventBus.on<PlayerMoveCompleted>().listen(
        _onPlayerMoveCompleted,
      ),
    );
    trackSubscription(
      _gameSessionEventBus.on<VirtualPlayerMoved>().listen(
        _onVirtualPlayerMoved,
      ),
    );
  }

  void _onPlayerMoveCompleted(PlayerMoveCompleted ev) {
    unawaited(
      _runAnimation(
        playerId: ev.event.playerId,
        path: ev.event.selectedPath,
        finalEvent: ev.event,
      ),
    );
  }

  Future<void> _onVirtualPlayerMoved(VirtualPlayerMoved ev) async {
    final event = ev.event;
    final boardState = _boardRepository.state.value;
    final destinationPosition = event.path.isNotEmpty
        ? Option.of(event.path.last)
        : const Option<GameBoardPosition>.none();
    final destinationItem = boardState.itemAtPathDestination(event.path);
    final movedEvent = PlayerMovedEvent(
      playerId: event.playerId,
      movementPoints: event.remainingMovementPoints,
      selectedPath: event.path,
    );
    await _runAnimation(
      playerId: event.playerId,
      path: event.path,
      finalEvent: movedEvent,
    );
    _gameSessionEventBus.fire(
      VirtualPlayerMoveCompleted(
        event: event,
        destinationPosition: destinationPosition,
        destinationItem: destinationItem,
      ),
    );
  }

  Future<void> _runAnimation({
    required String playerId,
    required List<GameBoardPosition> path,
    required PlayerMovedEvent finalEvent,
  }) async {
    if (path.length < 2) {
      _applyFinalState(finalEvent, playerId);
      return;
    }
    _interactionRepository.setMode(BoardInteractionMode.moving);
    for (var i = 1; i < path.length; i++) {
      final orientation = orientationFromStep(path[i - 1], path[i]);
      final step = PlayerMovementStepEvent(
        playerId: playerId,
        destination: path[i],
        orientation: orientation,
      );
      _boardRepository.applyMovementStep(step);
      _playerRepository.applyMovementStep(step);
      if (i < path.length - 1) {
        await Future.delayed(
          const Duration(milliseconds: GameRulesConstants.movementStepDelayMs),
        );
      }
    }
    await Future.delayed(
      const Duration(milliseconds: GameRulesConstants.movementStepDelayMs),
    );
    _applyFinalState(finalEvent, playerId);
  }

  void _applyFinalState(PlayerMovedEvent event, String playerId) {
    _gameSessionEventBus.fire(
      PlayerMoveAnimationCompleted(event: event, playerId: playerId),
    );
  }
}

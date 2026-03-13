import 'dart:async';

import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/constants/game_rules_constants.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../core/helpers/can_player_move_or_act.dart';
import '../../domain/commands/game_action_commands.dart';
import '../../domain/events/game_events.dart';
import '../../domain/state/game_session_state.dart';
import '../repositories/game_actions_repository.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_metadata_repository.dart';
import '../repositories/game_player_repository.dart';
import '../repositories/game_turn_repository.dart';
import '../services/game_events_socket.dart';

class GameTurnAutoForwardSideEffect with DisposableSideEffect {
  final String _socketId;
  final GameSessionEventBus _gameSessionEventBus;
  final GameActionsRepository _actionsRepository;
  final GameBoardRepository _boardRepository;
  final GameTurnRepository _turnRepository;
  final GamePlayerRepository _playerRepository;
  final GameMetadataRepository _metadataRepository;
  final GameEventsSocket _eventsSocket;
  Timer? _turnStartAutoForwardTimer;

  GameTurnAutoForwardSideEffect({
    required String socketId,
    required GameSessionEventBus gameSessionEventBus,
    required GameActionsRepository actionsRepository,
    required GameBoardRepository boardRepository,
    required GameTurnRepository turnRepository,
    required GamePlayerRepository playerRepository,
    required GameMetadataRepository metadataRepository,
    required GameEventsSocket eventsSocket,
  }) : _socketId = socketId,
       _gameSessionEventBus = gameSessionEventBus,
       _actionsRepository = actionsRepository,
       _boardRepository = boardRepository,
       _turnRepository = turnRepository,
       _playerRepository = playerRepository,
       _metadataRepository = metadataRepository,
       _eventsSocket = eventsSocket {
    trackSubscription(
      _gameSessionEventBus.on<PlayerMoveAnimationCompleted>().listen(
        _onPlayerMoveAnimationCompleted,
      ),
    );
    trackSubscription(_eventsSocket.turnStartingStream.listen(_onTurnStarting));
  }

  void _onPlayerMoveAnimationCompleted(PlayerMoveAnimationCompleted ev) {
    final event = ev.event;
    if (event.playerId != _socketId) return;
    if (_turnRepository.state.value.currentPlayerId != _socketId) return;
    if (canPlayerMoveOrAct(
      _socketId,
      _playerRepository.state.value,
      _boardRepository.state.value,
      _metadataRepository.state.value,
    )) {
      return;
    }
    _forwardTurnIfActive();
  }

  void _onTurnStarting(TurnStartingEvent event) {
    final nextPlayerId = event.nextPlayerId;
    _turnStartAutoForwardTimer?.cancel();
    if (nextPlayerId != _socketId) return;
    _turnStartAutoForwardTimer = Timer(
      const Duration(
        milliseconds: GameRulesConstants.turnStartAutoForwardDelayMs,
      ),
      _onTurnStartAutoForwardDelayComplete,
    );
  }

  void _onTurnStartAutoForwardDelayComplete() {
    _turnStartAutoForwardTimer = null;
    if (_turnRepository.state.value.currentPlayerId != _socketId) return;
    if (canPlayerMoveOrAct(
      _socketId,
      _playerRepository.state.value,
      _boardRepository.state.value,
      _metadataRepository.state.value,
    )) {
      return;
    }
    _forwardTurnIfActive();
  }

  void _forwardTurnIfActive() {
    final meta = _metadataRepository.state.value;
    if (meta is! GameSessionActive) return;
    if (!_turnRepository.state.value.canForwardTurn) return;
    _actionsRepository.forwardTurn(ForwardTurnCommand(roomId: meta.roomId));
  }

  @override
  void dispose() {
    _turnStartAutoForwardTimer?.cancel();
    _turnStartAutoForwardTimer = null;
    super.dispose();
  }
}

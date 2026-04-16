import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../domain/events/game_combat_events.dart';
import '../../domain/state/game_combat_state.dart';
import '../repositories/game_combat_repository.dart';
import '../services/game_combat_socket.dart';

class GameCombatEventsProjection implements EventProjection {
  final GameCombatSocket _combatSocket;
  final GameCombatRepository _combatRepository;
  final GameSessionEventBus _gameSessionEventBus;
  final String _socketId;
  final List<AttackResultEvent> _pendingAttackResults = [];

  GameCombatEventsProjection({
    required GameCombatSocket combatSocket,
    required GameCombatRepository combatRepository,
    required GameSessionEventBus gameSessionEventBus,
    required String socketId,
  }) : _combatSocket = combatSocket,
       _combatRepository = combatRepository,
       _gameSessionEventBus = gameSessionEventBus,
       _socketId = socketId;

  @override
  List<StreamSubscription> subscribe() => [
    _combatSocket.combatTurnStartedStream
        .where(_isParticipant)
        .listen(_onCombatTurnStarted),
    _combatSocket.attackResultStream.listen(_onAttackResult),
    _combatSocket.flightAttemptResultStream.listen(_onFlightAttemptResult),
    _combatSocket.endCombatStream.listen(_onEndCombat),
    _combatSocket.combatCountdownStream
        .map((seconds) => CombatCountdownEvent(seconds: seconds))
        .listen(_combatRepository.applyCombatCountdown),
  ];

  void _onCombatTurnStarted(CombatTurnStartedEvent event) {
    _combatRepository.applyCombatTurnStarted(event);
    while (_pendingAttackResults.isNotEmpty) {
      final pending = _pendingAttackResults.removeAt(0);
      _onAttackResult(pending);
    }
  }

  bool _isParticipant(CombatTurnStartedEvent event) {
    return event.attackerId == _socketId || event.defenderId == _socketId;
  }

  void _onAttackResult(AttackResultEvent event) {
    final previous = _combatRepository.state.value;
    if (previous is! CombatActive) {
      _pendingAttackResults.add(event);
      return;
    }
    _combatRepository.applyAttackResult(event);
    if (!event.isAttackSuccess) return;
    final targetId = previous.currentOpponentIdRaw;
    _gameSessionEventBus.fire(
      CombatHealthUpdated(
        playerId: targetId,
        healthPoints: event.opponentHealthPoints,
      ),
    );
  }

  void _onFlightAttemptResult(FlightAttemptResultEvent event) {
    final currentState = _combatRepository.state.value;
    // Combat already finished (server sends endCombat to the game room); ignore stale flight packets.
    if (currentState is CombatIdle || currentState is CombatResolved) {
      return;
    }
    if (currentState is! CombatActive) {
      return;
    }
    // Angular combat.service: handleFlightResult / showFlightResult only run when
    // isCombatPlayerTurn — i.e. only the acting player's client updates flightAttemptsLeft and
    // flight toasts. Server emits flightAttemptResult for whoever is currentPlayerId.
    if (currentState.currentPlayerIdRaw != _socketId) {
      return;
    }
    if (event.isSuccess) {
      _combatRepository.armSuppressUpdateScoreAfterFlightEnd(_socketId);
    }
    _combatRepository.applyFlightAttemptResult(event);
  }

  void _onEndCombat(EndCombatResultEvent event) {
    // Mirrors Angular action-socket.service EndCombat handler.
    final trackedLocally = _combatRepository.state.value is! CombatIdle;
    final isInvolved =
        event.winnerId == _socketId || event.loserId == _socketId;

    if (event.isByFlight) {
      // Server can wrongly emit updateScore for the fleeing player; GamePlayerEventsProjection drops it.
      _combatRepository.armSuppressUpdateScoreAfterFlightEnd(event.winnerId);
      if (isInvolved) {
        if (trackedLocally) {
          _combatRepository.applyEndCombat(event);
        }
        _gameSessionEventBus.fire(
          GameCombatEnded(
            winnerId: event.winnerId,
            loserId: event.loserId,
            isByFlight: true,
          ),
        );
      }
      _pendingAttackResults.clear();
      return;
    }

    if (trackedLocally) {
      _combatRepository.applyEndCombat(event);
    }
    if (isInvolved) {
      _gameSessionEventBus.fire(
        GameCombatEnded(
          winnerId: event.winnerId,
          loserId: event.loserId,
          isByFlight: false,
        ),
      );
    }
    _pendingAttackResults.clear();
  }
}

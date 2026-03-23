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
  final List<FlightAttemptResultEvent> _pendingFlightAttemptResults = [];

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
        _combatSocket.combatTurnStartedStream
            .listen(_onCombatStartedForNotification),
        _combatSocket.attackResultStream.listen(_onAttackResult),
        _combatSocket.flightAttemptResultStream
            .listen(_onFlightAttemptResult),
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
    while (_pendingFlightAttemptResults.isNotEmpty) {
      final pending = _pendingFlightAttemptResults.removeAt(0);
      _combatRepository.applyFlightAttemptResult(pending);
    }
  }

  void _onCombatStartedForNotification(CombatTurnStartedEvent event) {
    if (_isParticipant(event)) return;
    _gameSessionEventBus.fire(
      CombatStarted(
        attackerId: event.attackerId,
        defenderId: event.defenderId,
      ),
    );
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
    if (currentState is! CombatActive) {
      _pendingFlightAttemptResults.add(event);
      return;
    }
    _combatRepository.applyFlightAttemptResult(event);
    if (!event.isSuccess) return;
    _finalizeCombatOnSuccessfulFlight(currentState);
  }

  void _finalizeCombatOnSuccessfulFlight(CombatActive combatState) {
    final fleeingPlayerId = combatState.currentPlayerIdRaw;
    final opponentPlayerId = combatState.currentOpponentIdRaw;
    _onEndCombat(
      EndCombatResultEvent(
        winnerId: fleeingPlayerId,
        loserId: opponentPlayerId,
        isByFlight: true,
      ),
    );
  }

  void _onEndCombat(EndCombatResultEvent event) {
    final trackedLocally = _combatRepository.state.value is! CombatIdle;
    final localPlayerWasParticipant =
        event.winnerId == _socketId || event.loserId == _socketId;
    if (trackedLocally) {
      _combatRepository.applyEndCombat(event);
    }
    if (trackedLocally || !localPlayerWasParticipant) {
      _gameSessionEventBus.fire(
        GameCombatEnded(
          winnerId: event.winnerId,
          loserId: event.loserId,
          isByFlight: event.isByFlight,
        ),
      );
    }
    _pendingAttackResults.clear();
    _pendingFlightAttemptResults.clear();
  }
}

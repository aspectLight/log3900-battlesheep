import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/events/game_combat_events.dart';
import '../../domain/commands/game_combat_commands.dart';
import '../services/game_combat_socket.dart';
import '../../domain/state/game_combat_state.dart';
import '../reducers/game_combat_state_reducer.dart';

class GameCombatRepository {
  final GameCombatSocket _combatSocket;
  final GameCombatStateReducer _reducer;

  final Signal<GameCombatState> state = signal(const GameCombatState.initial());

  /// Server may emit a spurious updateScore after combat ends by flight (flee-er id as winnerId).
  /// Arm when we process endCombat with isByFlight; consume one matching updateScore on the client.
  String? _suppressNextUpdateScoreWinnerId;

  GameCombatRepository({
    required GameCombatSocket combatSocket,
    required GameCombatStateReducer reducer,
  }) : _combatSocket = combatSocket,
       _reducer = reducer;

  void attack(AttackCommand command) {
    _combatSocket.attack(command);
  }

  void flightAttempt(FlightAttemptCommand command) {
    _combatSocket.flightAttempt(command);
  }

  void startCombat(StartCombatCommand command) {
    _combatSocket.startCombat(command);
  }

  void startVirtualCombat(StartVirtualCombatCommand command) {
    _combatSocket.startVirtualCombat(command);
  }

  void armSuppressUpdateScoreAfterFlightEnd(String fleeingPlayerId) {
    _suppressNextUpdateScoreWinnerId = fleeingPlayerId;
  }

  /// Returns true if this updateScore winner should not be applied (spurious post-flight score).
  bool consumeSuppressUpdateScoreIfMatches(String updateScoreWinnerId) {
    final id = _suppressNextUpdateScoreWinnerId;
    if (id == null || id != updateScoreWinnerId) return false;
    _suppressNextUpdateScoreWinnerId = null;
    return true;
  }

  void applyCombatTurnStarted(CombatTurnStartedEvent event) {
    _suppressNextUpdateScoreWinnerId = null;
    state.value = _reducer.reduce(state.value, event);
  }

  void applyAttackResult(AttackResultEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyFlightAttemptResult(FlightAttemptResultEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyEndCombat(EndCombatResultEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyCombatCountdown(CombatCountdownEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void clearCombatResults() {
    state.value = _reducer.reduce(
      state.value,
      const CombatResultsClearedEvent(),
    );
  }

  void clearFlightAttemptFeedback() {
    state.value = _reducer.reduce(
      state.value,
      const FlightAttemptFeedbackClearedEvent(),
    );
  }

  void clearCombatEndOverlay() {
    state.value = _reducer.reduce(
      state.value,
      const CombatEndOverlayClearedEvent(),
    );
  }
}

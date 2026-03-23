import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/events/game_events.dart';
import '../../domain/state/game_turn_state.dart';
import '../reducers/game_turn_state_reducer.dart';

class GameTurnRepository {
  final GameTurnStateReducer _reducer;

  final Signal<GameTurnState> state = signal(GameTurnState.initial());

  GameTurnRepository({required GameTurnStateReducer reducer})
      : _reducer = reducer;

  void applyTurnStarting(TurnStartingEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyStartingCountdown(UpdateStartingCountdownEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyGameCountdown(UpdateCountdownEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void setCanForwardTurn({required bool value}) {
    state.value = state.value.copyWith(canForwardTurn: value);
  }
}

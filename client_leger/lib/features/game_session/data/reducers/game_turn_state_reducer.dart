import '../../domain/events/game_events.dart';
import '../../domain/state/game_turn_state.dart';

class GameTurnStateReducer {
  GameTurnState reduce(GameTurnState previous, Object event) {
    if (event is TurnStartingEvent) {
      return _reduceTurnStarting(previous, event);
    }
    if (event is UpdateStartingCountdownEvent) {
      return _reduceUpdateStartingCountdown(previous, event);
    }
    if (event is UpdateCountdownEvent) {
      return _reduceUpdateCountdown(previous, event);
    }
    return previous;
  }

  GameTurnState _reduceTurnStarting(
    GameTurnState previous,
    TurnStartingEvent event,
  ) {
    return GameTurnState(
      currentPlayerId: event.nextPlayerId,
      turnCountdown: previous.turnCountdown,
      startCountdown: event.startTime,
      canForwardTurn: false,
    );
  }

  GameTurnState _reduceUpdateStartingCountdown(
    GameTurnState previous,
    UpdateStartingCountdownEvent event,
  ) {
    return previous.copyWith(startCountdown: event.countdown);
  }

  GameTurnState _reduceUpdateCountdown(
    GameTurnState previous,
    UpdateCountdownEvent event,
  ) {
    return previous.copyWith(turnCountdown: event.countdown);
  }
}

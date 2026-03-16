import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/app_events/game_session_events.dart';
import '../../core/enums/session_end_reason.dart';
import '../../core/event_bus/game_session_event_bus.dart';

class GameSessionEventSideEffect with DisposableSideEffect {
  GameSessionEventSideEffect({
    required AppTransitionEventBus appTransitionEventBus,
    required GameSessionEventBus gameSessionEventBus,
  }) : _appTransitionEventBus = appTransitionEventBus {
    trackSubscription(
      gameSessionEventBus.on<GameSessionCanceled>().listen((_) {
        _appTransitionEventBus.fire(
          const GameSessionExitAppEvent.sessionTerminated(SessionEndReason.canceled),
        );
      }),
    );
    trackSubscription(
      gameSessionEventBus.on<GameSessionAbandoned>().listen((_) {
        _appTransitionEventBus.fire(
          const GameSessionExitAppEvent.sessionTerminated(SessionEndReason.abandoned),
        );
      }),
    );
  }

  final AppTransitionEventBus _appTransitionEventBus;
}

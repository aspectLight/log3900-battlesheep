import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/app_events/join_game_session_events.dart';

class JoinGameSessionViewModel {
  JoinGameSessionViewModel({
    required AppTransitionEventBus appTransitionEventBus,
  }) : _appTransitionEventBus = appTransitionEventBus;

  final AppTransitionEventBus _appTransitionEventBus;

  void onBackTap() {
    _appTransitionEventBus.fire(
      const JoinGameSessionExitAppEvent.leaveRequested(),
    );
  }
}

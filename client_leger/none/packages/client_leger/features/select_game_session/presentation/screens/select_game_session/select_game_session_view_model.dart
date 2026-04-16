import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../core/app_events/select_game_session_events.dart';

class SelectGameSessionViewModel {
  SelectGameSessionViewModel({
    required AppTransitionEventBus appTransitionEventBus,
  }) : _appTransitionEventBus = appTransitionEventBus;

  final AppTransitionEventBus _appTransitionEventBus;

  void onBackButtonTap() {
    _appTransitionEventBus.fire(
      const SelectGameSessionExitAppEvent.cancelled(),
    );
  }

  void onPopRequested() {
    _appTransitionEventBus.fire(
      const SelectGameSessionExitAppEvent.cancelled(),
    );
  }
}

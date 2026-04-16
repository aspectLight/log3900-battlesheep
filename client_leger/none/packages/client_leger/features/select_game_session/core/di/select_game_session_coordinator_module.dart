import 'package:get_it/get_it.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../../routing/app_navigator.dart';
import '../coordinators/select_game_session_coordinator.dart';

void registerSelectGameSessionCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<SelectGameSessionCoordinator>(
    () => SelectGameSessionCoordinator(
      appNavigator: getIt<AppNavigator>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      sessionScopeManager: getIt<SessionScopeManager>(),
    ),
  );
}

import 'package:get_it/get_it.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';
import '../../../../../routing/app_navigator.dart';
import '../coordinators/join_game_session_coordinator.dart';

void registerJoinGameSessionCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<JoinGameSessionCoordinator>(
    () => JoinGameSessionCoordinator(
      appNavigator: getIt<AppNavigator>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
    ),
  );
}

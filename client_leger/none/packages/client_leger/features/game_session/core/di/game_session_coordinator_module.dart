import 'package:get_it/get_it.dart';

import '../../../../core/connected_scope/session_scope_manager.dart';
import '../context/game_session_scope_holder.dart';
import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/notification/notification_coordinator.dart';
import '../../../../routing/app_navigator.dart';
import '../../../game_history/data/repositories/game_history_repository.dart';
import '../coordinators/game_session_coordinator.dart';
import '../../data/reducers/game_metadata_state_reducer.dart';
import '../../data/services/game_service.dart';

void registerGameSessionCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<GameSessionCoordinator>(
    () => GameSessionCoordinator(
      getIt: getIt,
      sessionScopeManager: getIt<SessionScopeManager>(),
      gameSessionScopeHolder: getIt<GameSessionScopeHolder>(),
      appNavigator: getIt<AppNavigator>(),
      notificationCoordinator: getIt<NotificationCoordinator>(),
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      gameService: getIt<GameService>(),
      gameMetadataStateReducer: getIt<GameMetadataStateReducer>(),
      gameHistoryRepository: getIt<GameHistoryRepository>(),
    ),
  );
}

import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../routing/app_navigator.dart';
import '../../data/discussion_canals_socket.dart';
import '../../domain/interfaces/discussion_canals_repository.dart';
import '../../presentation/screens/discussion_canals_view_model.dart';
import '../coordinators/discussion_canals_coordinator.dart';

void registerDiscussionCanalsRoot(GetIt getIt) {
  getIt.registerLazySingleton<DiscussionCanalsCoordinator>(
    () => DiscussionCanalsCoordinator(appNavigator: getIt<AppNavigator>()),
  );
  getIt.registerLazySingleton<DiscussionCanalsRepository>(
    () => DiscussionCanalsSocket(
      socketService: getIt<SocketService>(),
      username: getIt<SessionScopeManager>().currentSession?.username ?? '',
    ),
  );
  getIt.registerLazySingleton<DiscussionCanalsViewModel>(
    () => DiscussionCanalsViewModel(
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      repository: getIt<DiscussionCanalsRepository>(),
    ),
  );
}

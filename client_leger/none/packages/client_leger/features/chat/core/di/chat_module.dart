import 'package:get_it/get_it.dart';

import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/di/scoped_projection_subscriptions.dart';
import '../../../../core/services/socket_service.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../data/projections/chat_events_projection.dart';
import '../../data/repositories/discussion_canals_repository.dart';
import '../../data/repositories/discussion_canals_socket.dart';
import '../../data/services/chat_socket.dart';
import '../../data/side_effects/chat_shake_side_effect.dart';
import '../context/chat_scope_holder.dart';
import '../coordinators/chat_coordinator.dart';
import 'chat_projection_module.dart';
import 'chat_reducer_module.dart';
import 'chat_side_effect_module.dart';
import 'chat_state_repository_module.dart';
import 'chat_view_model_module.dart';

void registerChatRoot(GetIt getIt) {
  getIt.registerLazySingleton<ChatScopeHolder>(ChatScopeHolder.new);
  getIt.registerLazySingleton<DiscussionCanalsRepository>(
    () => DiscussionCanalsSocket(
      socketService: getIt<SocketService>(),
      username: getIt<SessionScopeManager>().currentSession!.username,
      authRepository: getIt<AuthRepository>(),
    ),
  );
  registerChatReducer(getIt);
  registerChatCoordinator(getIt);
}

void registerChatCoordinator(GetIt getIt) {
  getIt.registerLazySingleton<ChatCoordinator>(
    () => ChatCoordinator(
      getIt: getIt,
      sessionScopeManager: getIt<SessionScopeManager>(),
      chatScopeHolder: getIt<ChatScopeHolder>(),
    ),
  );
}

void registerChatScope(
  GetIt scope,
  GetIt rootGetIt, {
  required String username,
}) {
  scope.registerSingleton<ChatSocket>(
    ChatSocket(socketService: rootGetIt<SocketService>()),
    dispose: (socket) => socket.dispose(),
  );
  registerChatRepositories(scope, rootGetIt);
  registerChatViewModels(scope, rootGetIt, username: username);
  registerChatProjection(scope, rootGetIt);
  registerChatSideEffects(scope, username: username);
}

void bootstrapChatScope(GetIt scope) {
  registerScopedProjectionSubscriptions(
    scope,
    scope.get<ChatEventsProjection>().subscribe(),
  );
  scope.get<ChatShakeSideEffect>();
}

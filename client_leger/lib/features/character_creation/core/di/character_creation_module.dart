import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/services/socket_service.dart';
import '../../../game_session/core/context/drop_in_join_sync_holder.dart';
import '../../../../routing/app_navigator.dart';
import '../../data/services/character_creation_socket.dart';
import '../../domain/models/character_creation_entry_mode.dart';
import '../context/character_creation_scope_holder.dart';
import '../coordinators/character_creation_coordinator.dart';
import '../event_bus/character_creation_event_bus.dart';
import 'character_creation_projection_module.dart';
import 'character_creation_repository_module.dart';
import 'character_creation_side_effect_module.dart';
import 'character_creation_use_case_module.dart';
import 'character_creation_view_model_module.dart';

void registerCharacterCreationRoot(GetIt getIt) {
  getIt.registerLazySingleton<CharacterCreationEventBus>(
    () => CharacterCreationEventBus(getIt<EventBus>()),
  );
  getIt.registerLazySingleton<CharacterCreationScopeHolder>(
    CharacterCreationScopeHolder.new,
  );
  getIt.registerLazySingleton<CharacterCreationCoordinator>(
    () => CharacterCreationCoordinator(
      getIt: getIt,
      appTransitionEventBus: getIt<AppTransitionEventBus>(),
      sessionScopeManager: getIt<SessionScopeManager>(),
      scopeHolder: getIt<CharacterCreationScopeHolder>(),
      appNavigator: getIt<AppNavigator>(),
    ),
  );
}

void registerCharacterCreationScope(
  GetIt scope,
  GetIt rootGetIt, {
  required String roomCode,
  required String socketId,
  required CharacterCreationEntryMode entryMode,
}) {
  scope.registerSingleton<CharacterCreationSocket>(
    CharacterCreationSocket(
      socketService: rootGetIt<SocketService>(),
      dropInJoinSyncHolder: rootGetIt<DropInJoinSyncHolder>(),
    ),
    dispose: (socket) => socket.dispose(),
  );
  registerCharacterCreationRepositories(scope, rootGetIt, roomCode: roomCode);
  registerCharacterCreationProjections(scope, rootGetIt);
  registerCharacterCreationSideEffects(scope, rootGetIt);
  registerCharacterCreationUseCases(
    scope,
    rootGetIt,
    roomCode: roomCode,
    socketId: socketId,
    entryMode: entryMode,
  );
  registerCharacterCreationScopeViewModels(
    scope,
    rootGetIt,
    socketId: socketId,
    entryMode: entryMode,
  );
  bootstrapCharacterCreationScope(scope);
}

import 'package:event_bus/event_bus.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/services/socket_service.dart';
import '../../../../routing/app_navigator.dart';
import '../../data/services/waiting_room_socket.dart';
import '../context/waiting_room_entry_data.dart';
import '../context/waiting_room_scope_holder.dart';
import '../typedefs/waiting_room_start_validation_params.dart';
import '../coordinators/waiting_room_coordinator.dart';
import '../event_bus/waiting_room_event_bus.dart';
import '../../data/side_effects/waiting_room_auto_lock_on_max_players_side_effect.dart';
import '../../data/side_effects/waiting_room_canceled_side_effect.dart';
import '../../data/side_effects/waiting_room_confirm_kick_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_confirm_leave_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_confirm_unlock_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_failure_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_game_started_side_effect.dart';
import '../../data/side_effects/waiting_room_player_kicked_side_effect.dart';
import '../../data/side_effects/waiting_room_room_locked_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_select_virtual_profile_notification_side_effect.dart';
import 'waiting_room_modal_module.dart';
import 'waiting_room_projection_module.dart';
import 'waiting_room_repository_module.dart';
import 'waiting_room_side_effect_module.dart';
import 'waiting_room_use_case_module.dart';
import 'waiting_room_view_model_module.dart';

void registerWaitingRoomRoot(GetIt getIt) {
  getIt.registerLazySingleton<WaitingRoomSocket>(
    () => WaitingRoomSocket(socketService: getIt<SocketService>()),
  );
  getIt.registerLazySingleton<WaitingRoomEventBus>(
    () => WaitingRoomEventBus(getIt<EventBus>()),
  );
  getIt.registerLazySingleton<WaitingRoomScopeHolder>(
    WaitingRoomScopeHolder.new,
  );
  getIt.registerLazySingleton<WaitingRoomCoordinator>(
    () => WaitingRoomCoordinator(
      getIt: getIt,
      sessionScopeManager: getIt<SessionScopeManager>(),
      scopeHolder: getIt<WaitingRoomScopeHolder>(),
      appNavigator: getIt<AppNavigator>(),
    ),
  );
  registerWaitingRoomModals(getIt);
}

void registerWaitingRoomScope(
  GetIt scope,
  GetIt rootGetIt, {
  required WaitingRoomEntryData entryData,
}) {
  scope.registerLazySingleton<WaitingRoomEntryData>(() => entryData);
  final (roomId, hostId, socketId) = (
    entryData.roomId,
    entryData.hostId,
    entryData.socketId,
  );
  final (boardSize, isCTF, initialRoom) = switch (entryData) {
    WaitingRoomHostEntryData(:final boardSize, :final isCTF) => (
      boardSize,
      isCTF,
      null,
    ),
    WaitingRoomJoinEntryData(:final initialRoom) => (
      null,
      null,
      initialRoom,
    ),
  };
  scope.registerLazySingleton<WaitingRoomStartValidationParams>(
    () => (boardSize: boardSize, isCTF: isCTF),
  );
  registerWaitingRoomRepositories(
    scope,
    rootGetIt,
    roomId: roomId,
    hostId: hostId,
    socketId: socketId,
    initialRoom: initialRoom,
  );
  registerWaitingRoomUseCases(scope, rootGetIt);
  registerWaitingRoomProjections(scope, rootGetIt);
  registerWaitingRoomSideEffect(scope, rootGetIt);
  registerWaitingRoomScopeViewModels(scope, rootGetIt);
  bootstrapWaitingRoomScope(scope);
  scope.get<WaitingRoomGameStartedSideEffect>();
  scope.get<WaitingRoomAutoLockOnMaxPlayersSideEffect>();
  scope.get<WaitingRoomCanceledSideEffect>();
  scope.get<WaitingRoomPlayerKickedSideEffect>();
  scope.get<WaitingRoomConfirmLeaveNotificationSideEffect>();
  scope.get<WaitingRoomConfirmKickNotificationSideEffect>();
  scope.get<WaitingRoomConfirmUnlockNotificationSideEffect>();
  scope.get<WaitingRoomSelectVirtualProfileNotificationSideEffect>();
  scope.get<WaitingRoomRoomLockedNotificationSideEffect>();
  scope.get<WaitingRoomFailureNotificationSideEffect>();
}

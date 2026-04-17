import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/modal/modal_intent_sink.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../context/waiting_room_entry_data.dart';
import '../../data/repositories/waiting_room_room_repository.dart';
import '../../data/services/waiting_room_socket.dart';
import '../../data/side_effects/waiting_room_auto_lock_on_max_players_side_effect.dart';
import '../../data/side_effects/waiting_room_canceled_side_effect.dart';
import '../../data/side_effects/waiting_room_game_started_side_effect.dart';
import '../../data/side_effects/waiting_room_confirm_kick_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_confirm_leave_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_confirm_unlock_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_failure_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_player_kicked_side_effect.dart';
import '../../data/side_effects/waiting_room_room_locked_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_reserve_failed_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_select_virtual_profile_notification_side_effect.dart';
import '../../data/side_effects/waiting_room_welcome_notification_side_effect.dart';
import '../event_bus/waiting_room_event_bus.dart';
import '../typedefs/waiting_room_start_validation_params.dart';

void registerWaitingRoomSideEffect(GetIt scope, GetIt rootGetIt) {
  final appTransitionEventBus = rootGetIt<AppTransitionEventBus>();
  final waitingRoomEventBus = rootGetIt<WaitingRoomEventBus>();
  final notificationIntentSink = rootGetIt<NotificationIntentSink>();
  final modalIntentSink = rootGetIt<ModalIntentSink>();
  scope.registerSingleton<WaitingRoomGameStartedSideEffect>(
    WaitingRoomGameStartedSideEffect(
      waitingRoomSocket: scope.get<WaitingRoomSocket>(),
      appTransitionEventBus: appTransitionEventBus,
      sessionScopeManager: rootGetIt<SessionScopeManager>(),
      entryData: scope.get<WaitingRoomEntryData>(),
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomAutoLockOnMaxPlayersSideEffect>(
    WaitingRoomAutoLockOnMaxPlayersSideEffect(
      waitingRoomSocket: scope.get<WaitingRoomSocket>(),
      roomRepository: scope.get<WaitingRoomRoomRepository>(),
      startParams: scope.get<WaitingRoomStartValidationParams>(),
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomCanceledSideEffect>(
    WaitingRoomCanceledSideEffect(
      appTransitionEventBus: appTransitionEventBus,
      waitingRoomEventBus: waitingRoomEventBus,
      notificationIntentSink: notificationIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomPlayerKickedSideEffect>(
    WaitingRoomPlayerKickedSideEffect(
      appTransitionEventBus: appTransitionEventBus,
      waitingRoomEventBus: waitingRoomEventBus,
      notificationIntentSink: notificationIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomReserveFailedNotificationSideEffect>(
    WaitingRoomReserveFailedNotificationSideEffect(
      waitingRoomEventBus: waitingRoomEventBus,
      waitingRoomSocket: scope.get<WaitingRoomSocket>(),
      notificationIntentSink: notificationIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomConfirmLeaveNotificationSideEffect>(
    WaitingRoomConfirmLeaveNotificationSideEffect(
      waitingRoomEventBus: waitingRoomEventBus,
      modalIntentSink: modalIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomConfirmKickNotificationSideEffect>(
    WaitingRoomConfirmKickNotificationSideEffect(
      waitingRoomEventBus: waitingRoomEventBus,
      modalIntentSink: modalIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomConfirmUnlockNotificationSideEffect>(
    WaitingRoomConfirmUnlockNotificationSideEffect(
      waitingRoomEventBus: waitingRoomEventBus,
      modalIntentSink: modalIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope
      .registerSingleton<WaitingRoomSelectVirtualProfileNotificationSideEffect>(
        WaitingRoomSelectVirtualProfileNotificationSideEffect(
          waitingRoomEventBus: waitingRoomEventBus,
          modalIntentSink: modalIntentSink,
        ),
        dispose: (sideEffect) => sideEffect.dispose(),
      );
  scope.registerSingleton<WaitingRoomRoomLockedNotificationSideEffect>(
    WaitingRoomRoomLockedNotificationSideEffect(
      waitingRoomEventBus: waitingRoomEventBus,
      notificationIntentSink: notificationIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomFailureNotificationSideEffect>(
    WaitingRoomFailureNotificationSideEffect(
      waitingRoomEventBus: waitingRoomEventBus,
      notificationIntentSink: notificationIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<WaitingRoomWelcomeNotificationSideEffect>(
    WaitingRoomWelcomeNotificationSideEffect(
      waitingRoomEventBus: waitingRoomEventBus,
      notificationIntentSink: notificationIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
}

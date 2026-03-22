import 'package:get_it/get_it.dart';

import '../../features/character_creation/presentation/widgets/character_creation_room_locked_notification/character_creation_room_locked_notification_widget.dart';
import '../../features/character_creation/presentation/widgets/character_creation_reserve_failed_notification/character_creation_reserve_failed_notification_widget.dart';
import '../../features/character_creation/presentation/widgets/character_creation_validation_notification/character_creation_validation_notification_widget.dart';
import '../../features/game_session/presentation/widgets/combat_started_notification/combat_started_notification_widget.dart';
import '../../features/game_session/presentation/widgets/end_combat_notification/end_combat_notification_widget.dart';
import '../../features/game_session/presentation/widgets/game_abandoned_notification/game_abandoned_notification_widget.dart';
import '../../features/game_session/presentation/widgets/game_canceled_notification/game_canceled_notification_widget.dart';
import '../../features/game_session/presentation/widgets/game_finish_notification/game_finish_notification_widget.dart';
import '../../features/game_session/presentation/widgets/game_inventory_full_discard_notification/game_inventory_full_discard_notification_widget.dart';
import '../../features/game_session/presentation/widgets/game_turn_notification/game_turn_notification_widget.dart';
import '../../features/join_game_session/presentation/widgets/join_game_session_failure_notification/join_game_session_failure_notification_widget.dart';
import '../../features/select_game_session/presentation/widgets/select_game_session_error_notification/select_game_session_error_notification_widget.dart';
import '../../features/waiting_room/presentation/widgets/character_already_used_notification/character_already_used_notification_widget.dart';
import '../../features/waiting_room/presentation/widgets/game_deleted_notification/game_deleted_notification_widget.dart';
import '../../features/waiting_room/presentation/widgets/player_kicked_notification/player_kicked_notification_widget.dart';
import '../../features/waiting_room/presentation/widgets/waiting_room_failure_notification/waiting_room_failure_notification_widget.dart';
import '../../features/waiting_room/presentation/widgets/waiting_room_room_locked_notification/waiting_room_room_locked_notification_widget.dart';
import '../../features/waiting_room/presentation/widgets/waiting_room_welcome_notification/waiting_room_welcome_notification_widget.dart';
import 'notification_coordinator.dart';
import 'notification_intent.dart';
import 'notification_intent_sink.dart';
import 'notification_widget_registry.dart';

void registerNotificationModule(GetIt getIt) {
  getIt.registerLazySingleton<NotificationCoordinator>(
    NotificationCoordinator.new,
  );
  getIt.registerLazySingleton<NotificationIntentSink>(
    () => getIt<NotificationCoordinator>(),
  );
  final registry = NotificationWidgetRegistry();
  registry.register<TurnStartNotificationIntent>(
    (c, intent, onDismiss) =>
        GameTurnNotificationWidget(intent: intent, onDismiss: onDismiss),
  );
  registry.register<FinishGameNotificationIntent>(
    (c, intent, onDismiss) =>
        GameFinishNotificationWidget(intent: intent, onDismiss: onDismiss),
  );
  registry.register<GameAbandonedNotificationIntent>(
    (c, intent, onDismiss) =>
        GameAbandonedNotificationWidget(intent: intent, onDismiss: onDismiss),
  );
  registry.register<GameCanceledNotificationIntent>(
    (c, intent, onDismiss) =>
        GameCanceledNotificationWidget(intent: intent, onDismiss: onDismiss),
  );
  registry.register<CombatStartedNotificationIntent>(
    (c, intent, onDismiss) => CombatStartedNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  registry.register<EndCombatNotificationIntent>(
    (c, intent, onDismiss) =>
        EndCombatNotificationWidget(intent: intent, onDismiss: onDismiss),
  );
  registry.register<InventoryFullDiscardIntent>(
    (c, intent, onDismiss) => GameInventoryFullDiscardNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  registry.register<JoinGameSessionFailureNotificationIntent>(
    (c, intent, onDismiss) => JoinGameSessionFailureNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  registry.register<SelectGameSessionErrorNotificationIntent>(
    (c, intent, onDismiss) => SelectGameSessionErrorNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  registry.register<CharacterCreationValidationNotificationIntent>(
    (c, intent, onDismiss) => CharacterCreationValidationNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  registry.register<CharacterCreationReserveFailedNotificationIntent>(
    (c, intent, onDismiss) => CharacterCreationReserveFailedNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  registry.register<CharacterCreationRoomLockedNotificationIntent>(
    (c, intent, onDismiss) => CharacterCreationRoomLockedNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  registry.register<WaitingRoomReserveFailedNotificationIntent>(
    (c, intent, onDismiss) => CharacterAlreadyUsedNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  registry.register<WaitingRoomDeletedNotificationIntent>(
    (c, intent, onDismiss) =>
        GameDeletedNotificationWidget(intent: intent, onDismiss: onDismiss),
  );
  registry.register<WaitingRoomPlayerKickedNotificationIntent>(
    (c, intent, onDismiss) =>
        PlayerKickedNotificationWidget(intent: intent, onDismiss: onDismiss),
  );
  registry.register<WaitingRoomRoomLockedNotificationIntent>(
    (c, intent, onDismiss) =>
        WaitingRoomRoomLockedNotificationWidget(
          intent: intent,
          onDismiss: onDismiss,
        ),
  );
  registry.register<WaitingRoomFailureNotificationIntent>(
    (c, intent, onDismiss) =>
        WaitingRoomFailureNotificationWidget(
          intent: intent,
          onDismiss: onDismiss,
        ),
  );
  registry.register<WaitingRoomWelcomeNotificationIntent>(
    (c, intent, onDismiss) => WaitingRoomWelcomeNotificationWidget(
      intent: intent,
      onDismiss: onDismiss,
    ),
  );
  getIt.registerLazySingleton<NotificationWidgetRegistry>(() => registry);
}

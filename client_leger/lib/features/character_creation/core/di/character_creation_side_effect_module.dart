import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../data/side_effects/character_creation_room_locked_notification_side_effect.dart';
import '../../data/side_effects/character_creation_reserve_failed_notification_side_effect.dart';
import '../event_bus/character_creation_event_bus.dart';

void registerCharacterCreationSideEffects(GetIt scope, GetIt rootGetIt) {
  final eventBus = rootGetIt.get<CharacterCreationEventBus>();
  final notificationIntentSink = rootGetIt.get<NotificationIntentSink>();
  scope.registerSingleton<CharacterCreationReserveFailedNotificationSideEffect>(
    CharacterCreationReserveFailedNotificationSideEffect(
      eventBus: eventBus,
      notificationIntentSink: notificationIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
  scope.registerSingleton<CharacterCreationRoomLockedNotificationSideEffect>(
    CharacterCreationRoomLockedNotificationSideEffect(
      appTransitionEventBus: rootGetIt.get<AppTransitionEventBus>(),
      eventBus: eventBus,
      notificationIntentSink: notificationIntentSink,
    ),
    dispose: (sideEffect) => sideEffect.dispose(),
  );
}

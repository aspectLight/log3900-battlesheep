import 'package:get_it/get_it.dart';

import '../../../../core/notification/notification_intent_sink.dart';
import '../../data/side_effects/join_game_session_failure_notification_side_effect.dart';
import '../event_bus/join_game_session_event_bus.dart';

void registerJoinGameSessionSideEffects(GetIt getIt) {
  getIt.registerLazySingleton<JoinGameSessionFailureNotificationSideEffect>(
    () => JoinGameSessionFailureNotificationSideEffect(
      eventBus: getIt<JoinGameSessionEventBus>(),
      notificationIntentSink: getIt<NotificationIntentSink>(),
    ),
  );
}

void bootstrapJoinGameSessionSideEffects(GetIt getIt) {
  getIt.get<JoinGameSessionFailureNotificationSideEffect>();
}

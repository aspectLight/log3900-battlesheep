import 'package:get_it/get_it.dart';

import '../../../../core/notification/notification_intent_sink.dart';
import '../../data/side_effects/select_game_session_error_notification_side_effect.dart';
import '../event_bus/select_game_session_event_bus.dart';

void registerSelectGameSessionSideEffects(GetIt getIt) {
  getIt.registerLazySingleton<SelectGameSessionErrorNotificationSideEffect>(
    () => SelectGameSessionErrorNotificationSideEffect(
      eventBus: getIt<SelectGameSessionEventBus>(),
      notificationIntentSink: getIt<NotificationIntentSink>(),
    ),
  );
}

void bootstrapSelectGameSessionSideEffects(GetIt getIt) {
  getIt.get<SelectGameSessionErrorNotificationSideEffect>();
}

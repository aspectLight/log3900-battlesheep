import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/character_creation_event_bus.dart';

class CharacterCreationReserveFailedNotificationSideEffect with DisposableSideEffect {
  CharacterCreationReserveFailedNotificationSideEffect({
    required CharacterCreationEventBus eventBus,
    required NotificationIntentSink notificationIntentSink,
  })  : _eventBus = eventBus,
        _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      _eventBus
          .on<CharacterCreationReserveFailedEvent>()
          .listen(_onReserveFailed),
    );
  }

  final CharacterCreationEventBus _eventBus;
  final NotificationIntentSink _notificationIntentSink;

  void _onReserveFailed(CharacterCreationReserveFailedEvent event) {
    _notificationIntentSink.addIntent(
      CharacterCreationReserveFailedNotificationIntent(event.failure),
    );
  }
}


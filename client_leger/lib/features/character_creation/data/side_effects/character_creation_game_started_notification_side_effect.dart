import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/app_events/character_creation_events.dart';
import '../../core/event_bus/character_creation_event_bus.dart';

class CharacterCreationGameStartedNotificationSideEffect
    with DisposableSideEffect {
  CharacterCreationGameStartedNotificationSideEffect({
    required AppTransitionEventBus appTransitionEventBus,
    required CharacterCreationEventBus eventBus,
    required NotificationIntentSink notificationIntentSink,
  }) : _appTransitionEventBus = appTransitionEventBus,
       _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      eventBus.on<CharacterCreationGameStartedEvent>().listen(_onGameStarted),
    );
  }

  final AppTransitionEventBus _appTransitionEventBus;
  final NotificationIntentSink _notificationIntentSink;

  void _onGameStarted(CharacterCreationGameStartedEvent _) {
    _notificationIntentSink.addIntent(
      CharacterCreationGameStartedNotificationIntent(
        onDismissAction: () => _appTransitionEventBus.fire(
          const CharacterCreationExitAppEvent.exitRequested(),
        ),
      ),
    );
  }
}

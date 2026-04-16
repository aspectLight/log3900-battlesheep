import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/services/game_events_socket.dart';
import '../../domain/events/game_events.dart';

class GameTurnStartNotificationSideEffect with DisposableSideEffect {
  final GamePlayerRepository _playerRepository;
  final NotificationIntentSink _notificationIntentSink;

  GameTurnStartNotificationSideEffect({
    required GameEventsSocket eventsSocket,
    required GamePlayerRepository playerRepository,
    required NotificationIntentSink notificationIntentSink,
  }) : _playerRepository = playerRepository,
       _notificationIntentSink = notificationIntentSink {
    trackSubscription(eventsSocket.turnStartingStream.listen(_onTurnStarting));
  }

  void _onTurnStarting(TurnStartingEvent event) {
    final name = _playerRepository.state.value.players
        .where((p) => p.id == event.nextPlayerId)
        .map((p) => p.name)
        .firstOrNull;
    if (name == null) return;
    final countdownSeconds = event.startTime <= 0 ? 1 : event.startTime;
    _notificationIntentSink.addIntent(
      TurnStartNotificationIntent(
        playerName: name,
        countdownSeconds: countdownSeconds,
      ),
    );
  }
}

import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../repositories/game_player_repository.dart';

class GameCombatStartedNotificationSideEffect with DisposableSideEffect {
  final GamePlayerRepository _playerRepository;
  final NotificationIntentSink _notificationIntentSink;

  GameCombatStartedNotificationSideEffect({
    required GameSessionEventBus gameSessionEventBus,
    required GamePlayerRepository playerRepository,
    required NotificationIntentSink notificationIntentSink,
  }) : _playerRepository = playerRepository,
       _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      gameSessionEventBus.on<CombatStarted>().listen(_onCombatStarted),
    );
  }

  void _onCombatStarted(CombatStarted event) {
    final state = _playerRepository.state.value;
    final attackerName = state
        .findById(event.attackerId)
        .fold(() => event.attackerId, (p) => p.name);
    final defenderName = state
        .findById(event.defenderId)
        .fold(() => event.defenderId, (p) => p.name);
    _notificationIntentSink.addIntent(
      CombatStartedNotificationIntent(
        attackerName: attackerName,
        defenderName: defenderName,
      ),
    );
  }
}

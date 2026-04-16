import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/item_type.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../../../core/notification/notification_intent_sink.dart';
import '../../core/constants/combat_ui_constants.dart';
import '../../core/enums/stat_type.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../domain/commands/game_movement_commands.dart';
import '../../domain/events/game_events.dart';
import '../../domain/state/game_combat_state.dart';
import '../repositories/game_combat_repository.dart';
import '../repositories/game_metadata_repository.dart';
import '../repositories/game_player_movement_repository.dart';
import '../repositories/game_player_repository.dart';

class GameCombatSideEffect with DisposableSideEffect {
  final String _socketId;
  final GameCombatRepository _combatRepository;
  final GamePlayerRepository _playerRepository;
  final GamePlayerMovementRepository _movementRepository;
  final GameMetadataRepository _metadataRepository;
  final NotificationIntentSink _notificationIntentSink;
  Timer? _combatResultsClearTimer;
  Timer? _flightAttemptFeedbackClearTimer;
  Option<bool> _lastFlightAttemptSuccess = const Option.none();
  Option<int> _initialSelfHealth = const Option.none();
  Option<String> _enemyId = const Option.none();
  Option<int> _initialEnemyHealth = const Option.none();

  GameCombatSideEffect({
    required String socketId,
    required GameCombatRepository combatRepository,
    required GamePlayerRepository playerRepository,
    required GamePlayerMovementRepository movementRepository,
    required GameMetadataRepository metadataRepository,
    required GameSessionEventBus gameSessionEventBus,
    required NotificationIntentSink notificationIntentSink,
  }) : _socketId = socketId,
       _combatRepository = combatRepository,
       _playerRepository = playerRepository,
       _movementRepository = movementRepository,
       _metadataRepository = metadataRepository,
       _notificationIntentSink = notificationIntentSink {
    trackSubscription(
      gameSessionEventBus.on<GameCombatEnded>().listen(_onGameCombatEnded),
    );
    trackSubscription(
      gameSessionEventBus.on<CombatHealthUpdated>().listen(
        _onCombatHealthUpdated,
      ),
    );
    trackEffect(_scheduleCombatFeedbackClears);
  }

  void _cachePreCombatHealthIfNeeded() {
    final combat = _combatRepository.state.value;
    if (combat is! CombatActive) return;
    final attackerIdOpt = combat.attackerId;
    final defenderIdOpt = combat.defenderId;
    if (attackerIdOpt.isNone() || defenderIdOpt.isNone()) return;
    final attackerId = attackerIdOpt.getOrElse(() => '');
    final defenderId = defenderIdOpt.getOrElse(() => '');
    if (attackerId != _socketId && defenderId != _socketId) return;
    final enemyId = attackerId == _socketId ? defenderId : attackerId;
    if (_enemyId.contains(enemyId) &&
        _initialSelfHealth.isSome() &&
        _initialEnemyHealth.isSome()) {
      return;
    }
    final state = _playerRepository.state.value;
    final self = state.findById(_socketId);
    final enemy = state.findById(enemyId);
    _enemyId = Option.of(enemyId);
    _initialSelfHealth = self.map((p) => p.statValue(StatType.health));
    _initialEnemyHealth = enemy.map((p) => p.statValue(StatType.health));
  }

  void _onGameCombatEnded(GameCombatEnded event) {
    if (_socketId == event.winnerId || _socketId == event.loserId) {
      _notificationIntentSink.addIntent(
        EndCombatNotificationIntent(
          winnerId: event.winnerId,
          loserId: event.loserId,
          isByFlight: event.isByFlight,
          currentUserSocketId: _socketId,
        ),
      );
      // Resets pre-combat health locally on combat end; the server does
      // not always send an immediate post-combat "respawn/restore" update.
      // We mirror that behavior to avoid the HUD being stuck at 0 after combat.
      _initialSelfHealth.whenPresent((health) {
        _playerRepository.applyPlayerHealthUpdated(
          PlayerHealthUpdatedEvent(playerId: _socketId, healthPoints: health),
        );
      });
      Option.Do(($) {
        final enemyId = $(_enemyId);
        final enemyHealth = $(_initialEnemyHealth);
        _playerRepository.applyPlayerHealthUpdated(
          PlayerHealthUpdatedEvent(
            playerId: enemyId,
            healthPoints: enemyHealth,
          ),
        );
      });
      _initialSelfHealth = const Option.none();
      _enemyId = const Option.none();
      _initialEnemyHealth = const Option.none();
    }
    if (event.isByFlight) return;
    final loserOpt = _playerRepository.state.value.findById(event.loserId);
    loserOpt.whenPresent((loser) {
      final meta = _metadataRepository.state.value;
      final shouldSendTeleport =
          _socketId == event.loserId ||
          (loser.isVirtual && _socketId == meta.hostId);
      if (!shouldSendTeleport) return;
      final hasCamouflage = loser.inventory.any(
        (item) => item?.type == ItemType.camouflage,
      );
      _movementRepository.teleportPlayer(
        PlayerTeleportedCommand(
          roomId: meta.roomId,
          playerId: event.loserId,
          destination: loser.spawnPoint,
          hasCamouflage: hasCamouflage,
        ),
      );
    });
  }

  void _onCombatHealthUpdated(CombatHealthUpdated event) {
    _playerRepository.applyPlayerHealthUpdated(
      PlayerHealthUpdatedEvent(
        playerId: event.playerId,
        healthPoints: event.healthPoints,
      ),
    );
  }

  void _scheduleCombatFeedbackClears() {
    final combat = _combatRepository.state.value;
    _cachePreCombatHealthIfNeeded();
    if (combat is CombatWithResult) {
      _combatResultsClearTimer?.cancel();
      _combatResultsClearTimer = Timer(
        const Duration(milliseconds: CombatUiConstants.notificationDurationMs),
        _combatRepository.clearCombatResults,
      );
    } else {
      _combatResultsClearTimer?.cancel();
      _combatResultsClearTimer = null;
    }
    final flightAttemptSuccess = combat.lastFlightAttemptSuccess;
    if (flightAttemptSuccess.isSome() &&
        flightAttemptSuccess != _lastFlightAttemptSuccess) {
      _lastFlightAttemptSuccess = flightAttemptSuccess;
      _flightAttemptFeedbackClearTimer?.cancel();
      _flightAttemptFeedbackClearTimer = Timer(
        const Duration(milliseconds: CombatUiConstants.notificationDurationMs),
        _combatRepository.clearFlightAttemptFeedback,
      );
    }
    if (flightAttemptSuccess.isNone()) {
      _lastFlightAttemptSuccess = const Option.none();
      _flightAttemptFeedbackClearTimer?.cancel();
      _flightAttemptFeedbackClearTimer = null;
    }
  }
}

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/constants/game_debug_constants.dart';
import '../../domain/commands/game_debug_commands.dart';
import '../../domain/state/game_session_state.dart';
import '../repositories/game_debug_repository.dart';
import '../repositories/game_metadata_repository.dart';

class GameDebugShakeSideEffect with DisposableSideEffect {
  final String _socketId;
  final GameMetadataRepository _metadataRepository;
  final GameDebugRepository _debugRepository;

  int _horizontalShakeCount = 0;
  DateTime? _firstShakeInSequence;
  DateTime? _lastShakeTime;

  GameDebugShakeSideEffect({
    required String socketId,
    required GameMetadataRepository metadataRepository,
    required GameDebugRepository debugRepository,
  }) : _socketId = socketId,
       _metadataRepository = metadataRepository,
       _debugRepository = debugRepository {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    // Linear acceleration (gravity removed) — raw accelerometer often keeps |y|
    // above the horizontal dead zone unless the phone is perfectly flat.
    final sub = userAccelerometerEventStream().listen(_onUserAccelerometerEvent);
    trackSubscription(sub);
  }

  void _onUserAccelerometerEvent(UserAccelerometerEvent event) {
    final now = DateTime.now();
    final isHorizontalShake =
        event.x.abs() > GameDebugConstants.shakeThresholdHorizontal &&
        event.y.abs() < GameDebugConstants.shakeDeadZone;
    if (!isHorizontalShake) return;
    if (_lastShakeTime != null &&
        now.difference(_lastShakeTime!).inMilliseconds <
            GameDebugConstants.shakeMinIntervalMs) {
      return;
    }
    _lastShakeTime = now;
    _firstShakeInSequence ??= now;
    if (now.difference(_firstShakeInSequence!).inMilliseconds >
        GameDebugConstants.shakeSequenceWindowMs) {
      if (kDebugMode) {
        debugPrint(
          '[DebugShake] sequence reset (>${GameDebugConstants.shakeSequenceWindowMs}ms) '
          'had $_horizontalShakeCount/3',
        );
      }
      _resetSequence();
      _firstShakeInSequence = now;
    }
    _horizontalShakeCount++;
    if (kDebugMode) {
      debugPrint(
        '[DebugShake] horizontal hit $_horizontalShakeCount/'
        '${GameDebugConstants.shakesRequiredCount} '
        '(x=${event.x.toStringAsFixed(1)} y=${event.y.toStringAsFixed(1)})',
      );
    }
    if (_horizontalShakeCount >= GameDebugConstants.shakesRequiredCount) {
      _tryToggleDebugMode();
      _resetSequence();
    }
  }

  void _resetSequence() {
    _horizontalShakeCount = 0;
    _firstShakeInSequence = null;
  }

  void _tryToggleDebugMode() {
    final meta = _metadataRepository.state.value;
    if (meta.hostId != _socketId) {
      if (kDebugMode) {
        debugPrint(
          '[DebugShake] 3 shakes OK but toggle skipped (not host: '
          'hostId=${meta.hostId}, me=$_socketId)',
        );
      }
      return;
    }
    final roomId = switch (meta) {
      GameSessionActive(:final roomId) => roomId,
      GameSessionFinished(:final roomId) => roomId,
    };
    if (kDebugMode) {
      debugPrint('[DebugShake] sending toggle debug mode roomId=$roomId');
    }
    _debugRepository.toggleDebugMode(ToggleDebugModeCommand(roomId: roomId));
  }
}

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

  int _shakeCount = 0;
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
    // Raw accelerometer (same as chat) so the same physical motion hits similar values.
    final sub = accelerometerEventStream().listen(_onAccelerometerEvent);
    trackSubscription(sub);
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    final now = DateTime.now();
    // App is landscape-locked; screen top-to-bottom maps to device X, in-plane
    // “horizontal” on screen to device Y.
    final alongScreenVertical = event.x.abs();
    final alongScreenHorizontal = event.y.abs();
    final isVerticalOnScreenShake =
        alongScreenVertical > GameDebugConstants.shakeThresholdVertical &&
        alongScreenHorizontal < GameDebugConstants.shakeDeadZone;
    if (!isVerticalOnScreenShake) return;
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
          'had $_shakeCount/3',
        );
      }
      _resetSequence();
      _firstShakeInSequence = now;
    }
    _shakeCount++;
    if (kDebugMode) {
      debugPrint(
        '[DebugShake] vertical-on-screen hit $_shakeCount/'
        '${GameDebugConstants.shakesRequiredCount} '
        '(x=${event.x.toStringAsFixed(1)} y=${event.y.toStringAsFixed(1)})',
      );
    }
    if (_shakeCount >= GameDebugConstants.shakesRequiredCount) {
      _tryToggleDebugMode();
      _resetSequence();
    }
  }

  void _resetSequence() {
    _shakeCount = 0;
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

import 'dart:io';

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
    final sub = accelerometerEventStream().listen(_onAccelerometerEvent);
    trackSubscription(sub);
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
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
      _resetSequence();
      _firstShakeInSequence = now;
    }
    _horizontalShakeCount++;
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
    if (meta.hostId != _socketId) return;
    final roomId = switch (meta) {
      GameSessionActive(:final roomId) => roomId,
      GameSessionFinished(:final roomId) => roomId,
    };
    _debugRepository.toggleDebugMode(ToggleDebugModeCommand(roomId: roomId));
  }
}

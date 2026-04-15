import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_environment_events.freezed.dart';

@freezed
class TrapPendingEvent with _$TrapPendingEvent {
  const factory TrapPendingEvent({
    required String roomId,
    required String playerId,
    required bool canAvoid,
  }) = _TrapPendingEvent;
}

@freezed
class BoardIlluminationUpdatedEvent with _$BoardIlluminationUpdatedEvent {
  const factory BoardIlluminationUpdatedEvent({
    required Set<String> illuminatedCellKeys,
  }) = _BoardIlluminationUpdatedEvent;
}

@freezed
class TorchPlayerStatPatch with _$TorchPlayerStatPatch {
  const factory TorchPlayerStatPatch({
    required String playerId,
    required int attack,
    required int defense,
  }) = _TorchPlayerStatPatch;
}

@freezed
class PlayerTorchStatsSyncEvent with _$PlayerTorchStatsSyncEvent {
  const factory PlayerTorchStatsSyncEvent({
    required List<TorchPlayerStatPatch> patches,
  }) = _PlayerTorchStatsSyncEvent;
}

@freezed
class TrapResultSyncEvent with _$TrapResultSyncEvent {
  const factory TrapResultSyncEvent({
    required String playerId,
    required int remainingMovementPoints,
    required bool activated,
  }) = _TrapResultSyncEvent;
}

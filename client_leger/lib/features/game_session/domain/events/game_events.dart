import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/board_character.dart';
import '../../core/enums/stat_type.dart';
import '../models/game_board_position.dart';
import '../models/game_item.dart';

part 'game_events.freezed.dart';

@freezed
class SpawnedPlayerEvent with _$SpawnedPlayerEvent {
  const factory SpawnedPlayerEvent({
    required String id,
    required String name,
    required BoardCharacterType characterType,
    required BoardCharacterColor color,
    required int movementPoints,
    required int actionPoints,
    required GameBoardPosition spawnPoint,
    required GameBoardPosition currentBoardPosition,
    @Default([]) List<GameItem> inventory,
    required Map<StatType, int> stats,
    required StatType diceChoice,
    @Default(false) bool isVirtual,
    required int team,
  }) = _SpawnedPlayerEvent;
}

@freezed
class PlayerSpawnedEvent with _$PlayerSpawnedEvent {
  const factory PlayerSpawnedEvent({
    required List<SpawnedPlayerEvent> players,
  }) = _PlayerSpawnedEvent;
}

@freezed
class TurnStartingEvent with _$TurnStartingEvent {
  const factory TurnStartingEvent({
    required String nextPlayerId,
    required int startTime,
    required int nextPlayerMovementPoints,
    required int nextPlayerActionPoints,
    @Default(false) bool isNextPlayerVirtual,
  }) = _TurnStartingEvent;

  const TurnStartingEvent._();
}

@freezed
class TurnStartingPlayerPointsEvent with _$TurnStartingPlayerPointsEvent {
  const factory TurnStartingPlayerPointsEvent({
    required String nextPlayerId,
    required int movementPoints,
    required int actionPoints,
  }) = _TurnStartingPlayerPointsEvent;
}

@freezed
class PlayerHealthUpdatedEvent with _$PlayerHealthUpdatedEvent {
  const factory PlayerHealthUpdatedEvent({
    required String playerId,
    required int healthPoints,
  }) = _PlayerHealthUpdatedEvent;
}

@freezed
class UpdateCountdownEvent with _$UpdateCountdownEvent {
  const factory UpdateCountdownEvent({required int countdown}) =
      _UpdateCountdownEvent;
}

@freezed
class UpdateStartingCountdownEvent with _$UpdateStartingCountdownEvent {
  const factory UpdateStartingCountdownEvent({required int countdown}) =
      _UpdateStartingCountdownEvent;
}

@freezed
class CurrentPlayerChangedEvent with _$CurrentPlayerChangedEvent {
  const factory CurrentPlayerChangedEvent({required String playerId}) =
      _CurrentPlayerChangedEvent;
}

@freezed
class UpdateScoreEvent with _$UpdateScoreEvent {
  const factory UpdateScoreEvent({
    required String winnerId,
    /// When set (server sends this), replaces the winner's win count (Angular parity).
    int? fightsWon,
  }) = _UpdateScoreEvent;
}

@freezed
class FinishGameEvent with _$FinishGameEvent {
  const factory FinishGameEvent({required String winnerId}) = _FinishGameEvent;
}

@freezed
class GameCanceledEvent with _$GameCanceledEvent {
  const factory GameCanceledEvent({required String playerId}) =
      _GameCanceledEvent;
}

@freezed
class GameAbandonedEvent with _$GameAbandonedEvent {
  const factory GameAbandonedEvent() = _GameAbandonedEvent;
}

@freezed
class PlayerAbandonedEvent with _$PlayerAbandonedEvent {
  const factory PlayerAbandonedEvent({required String playerId}) =
      _PlayerAbandonedEvent;
}

@freezed
class SpawnPointClearedEvent with _$SpawnPointClearedEvent {
  const factory SpawnPointClearedEvent({required GameBoardPosition position}) =
      _SpawnPointClearedEvent;
}

@freezed
class OrganizatorChangedEvent with _$OrganizatorChangedEvent {
  const factory OrganizatorChangedEvent({required String newHostId}) =
      _OrganizatorChangedEvent;
}

@freezed
class DoorToggledEvent with _$DoorToggledEvent {
  const factory DoorToggledEvent({required int x, required int y}) =
      _DoorToggledEvent;
}

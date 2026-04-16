import 'package:json_annotation/json_annotation.dart';

import '../../../../../core/converters/board_character_converters.dart';
import '../../../../../core/converters/stat_type_converters.dart';
import '../../../../../core/helpers/socket_numeric_payload.dart';
import '../../../core/constants/game_rules_constants.dart';
import '../../../core/enums/board_character.dart';
import '../../../core/enums/stat_type.dart';
import 'game_board_position_dto.dart';
import 'game_item_dto.dart';

part 'game_events_dto.g.dart';

/// Normalizes server payloads that may be a bare string, a list (socket_io_client
/// multi-arg frames), or a map with the given mapKey — same idea as
/// EndCombatResultDto.fromObject in game_combat_dto.dart.
String _parseSingleStringSocketEvent(dynamic data, {required String mapKey}) {
  String parseId(Object? v) => (v?.toString() ?? '').trim();

  if (data == null) {
    throw FormatException('Missing socket event payload', data);
  }
  if (data is String) {
    final id = parseId(data);
    if (id.isEmpty) {
      throw FormatException('Empty socket event payload', data);
    }
    return id;
  }
  if (data is List) {
    if (data.isEmpty) {
      throw FormatException('Empty list socket event payload', data);
    }
    final id = parseId(data.first);
    if (id.isEmpty) {
      throw FormatException('Empty id in socket event list', data);
    }
    return id;
  }
  if (data is Map) {
    final map = Map<String, dynamic>.from(data);
    final raw = map[mapKey];
    final id = parseId(raw);
    if (id.isEmpty) {
      throw FormatException('Missing or empty $mapKey in map', data);
    }
    return id;
  }
  final id = parseId(data);
  if (id.isEmpty) {
    throw FormatException('Unusable socket event payload', data);
  }
  return id;
}

@JsonSerializable()
class ToggleDoorCommandDto {
  final String roomId;
  final int x;
  final int y;

  const ToggleDoorCommandDto({
    required this.roomId,
    required this.x,
    required this.y,
  });

  factory ToggleDoorCommandDto.fromJson(Map<String, dynamic> json) =>
      _$ToggleDoorCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ToggleDoorCommandDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SpawnedPlayerDto {
  final String id;
  final String name;
  @JsonKey(name: 'avatar')
  @AvatarToCharacterTypeConverter()
  final BoardCharacterType characterType;
  @BoardCharacterColorConverter()
  final BoardCharacterColor color;
  final int movementPoints;
  final int actionPoints;
  final GameBoardPositionDto spawnPoint;

  /// Case courante sur le plateau (`position` côté serveur). Si null, on utilise [spawnPoint].
  @JsonKey(name: 'position')
  final GameBoardPositionDto? boardPosition;
  final List<GameItemDto> inventory;
  @StatTypeMapConverter()
  final Map<StatType, int> stats;
  @JsonKey(name: 'd6Choice')
  @StatTypeConverter()
  final StatType diceChoice;
  @JsonKey(name: 'd4Choice')
  @StatTypeConverter()
  final StatType d4Choice;
  final bool isVirtual;
  final int team;

  const SpawnedPlayerDto({
    required this.id,
    required this.name,
    required this.characterType,
    required this.color,
    required this.movementPoints,
    required this.actionPoints,
    required this.spawnPoint,
    this.boardPosition,
    required this.inventory,
    required this.stats,
    required this.diceChoice,
    required this.d4Choice,
    this.isVirtual = false,
    required this.team,
  });

  factory SpawnedPlayerDto.fromJson(Map<String, dynamic> json) =>
      _$SpawnedPlayerDtoFromJson(json);

  factory SpawnedPlayerDto.fromPlayerSpawnedPayload(Map<String, dynamic> map) {
    const avatarConverter = AvatarToCharacterTypeConverter();
    const colorConverter = BoardCharacterColorConverter();
    const statTypeConverter = StatTypeConverter();
    final spawnRaw = map['spawnPoint'];
    final posRaw = map['position'];
    final GameBoardPositionDto logicalSpawn;
    if (spawnRaw != null) {
      logicalSpawn = _readCoords(spawnRaw);
    } else {
      logicalSpawn = _readCoords(posRaw);
    }
    final GameBoardPositionDto? boardPosition = posRaw != null
        ? _readCoords(posRaw)
        : null;
    final invRaw = map['inventory'] as List<Object?>? ?? [];
    final inventory = invRaw
        .whereType<Map<String, dynamic>>()
        .map(GameItemDto.fromJson)
        .toList();
    final statsRaw = map['stats'] as Map<String, dynamic>? ?? {};
    final stats = <StatType, int>{};
    for (final type in StatType.values) {
      final obj = statsRaw[type.name];
      if (obj is Map<String, dynamic>) {
        final v = obj['value'];
        stats[type] = v is int ? v : (v is num ? v.toInt() : 0);
      } else {
        stats[type] = 0;
      }
    }
    final int speed = stats[StatType.speed] ?? 0;
    final avatarMap = map['avatar'] as Map<String, dynamic>?;
    final characterType = avatarMap != null && avatarMap.isNotEmpty
        ? avatarConverter.fromJson(avatarMap)
        : BoardCharacterType.values.first;
    final colorStr = map['color'] as String? ?? '';
    final color = colorStr.isNotEmpty
        ? colorConverter.fromJson(colorStr)
        : BoardCharacterColor.values.first;
    final d6Str = map['d6Choice'] as String?;
    final d4Str = map['d4Choice'] as String?;
    final bonusStr = map['bonusChoice'] as String?;
    final diceChoice = d6Str != null
        ? statTypeConverter.fromJson(d6Str)
        : (bonusStr != null
              ? statTypeConverter.fromJson(bonusStr)
              : StatType.health);
    final d4Choice = d4Str != null
        ? statTypeConverter.fromJson(d4Str)
        : StatType.health;
    final movementPointsRaw = map['movementPoints'];
    final int movementPoints = movementPointsRaw is int
        ? movementPointsRaw
        : (movementPointsRaw is num ? movementPointsRaw.toInt() : speed);
    final actionPointsRaw = map['actionPoints'];
    final int actionPoints = actionPointsRaw is int
        ? actionPointsRaw
        : (actionPointsRaw is num
              ? actionPointsRaw.toInt()
              : GameRulesConstants.actionPointsPerTurn);
    return SpawnedPlayerDto(
      id: map['id'] as String,
      name: map['name'] as String? ?? '',
      characterType: characterType,
      color: color,
      movementPoints: movementPoints,
      actionPoints: actionPoints,
      spawnPoint: logicalSpawn,
      boardPosition: boardPosition,
      inventory: inventory,
      stats: stats,
      diceChoice: diceChoice,
      d4Choice: d4Choice,
      isVirtual: map['isVirtual'] as bool? ?? false,
      team: (map['team'] as num?)?.toInt() ?? 0,
    );
  }

  static GameBoardPositionDto _readCoords(Object? value) {
    if (value is! Map<String, dynamic>) {
      return const GameBoardPositionDto(x: 0, y: 0);
    }
    final x = (value['x'] as num?)?.toInt() ?? 0;
    final y = (value['y'] as num?)?.toInt() ?? 0;
    return GameBoardPositionDto(x: x, y: y);
  }

  Map<String, dynamic> toJson() => _$SpawnedPlayerDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlayerSpawnedDto {
  final List<SpawnedPlayerDto> players;

  const PlayerSpawnedDto({required this.players});

  factory PlayerSpawnedDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerSpawnedDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerSpawnedDtoToJson(this);
}

@JsonSerializable()
class TurnStartingDto {
  final String nextPlayerId;
  final int startTime;
  final int nextPlayerMovementPoints;
  final int? nextPlayerActionPoints;
  final bool isNextPlayerVirtual;

  const TurnStartingDto({
    required this.nextPlayerId,
    required this.startTime,
    required this.nextPlayerMovementPoints,
    this.nextPlayerActionPoints,
    this.isNextPlayerVirtual = false,
  });

  factory TurnStartingDto.fromJson(Map<String, dynamic> json) =>
      _$TurnStartingDtoFromJson(json);

  factory TurnStartingDto.fromObject(dynamic data) {
    final payload = data as Map<String, dynamic>;
    final nextPlayer = payload['nextPlayer'] as Map<String, dynamic>;
    final breakSeconds =
        tryParseSocketWholeNumber(
          payload['countdown'] ?? payload['startTime'],
        ) ??
        0;
    final movementPoints = tryParseSocketWholeNumber(
      nextPlayer['movementPoints'],
    );
    if (movementPoints == null) {
      throw const FormatException('TurnStarting nextPlayer.movementPoints');
    }
    final actionPoints = tryParseSocketWholeNumber(nextPlayer['actionPoints']);
    return TurnStartingDto(
      nextPlayerId: nextPlayer['id'] as String,
      startTime: breakSeconds,
      nextPlayerMovementPoints: movementPoints,
      nextPlayerActionPoints: actionPoints,
      isNextPlayerVirtual: nextPlayer['isVirtual'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => _$TurnStartingDtoToJson(this);
}

@JsonSerializable()
class UpdateCountdownDto {
  final int countdown;

  const UpdateCountdownDto({required this.countdown});

  factory UpdateCountdownDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateCountdownDtoFromJson(json);

  factory UpdateCountdownDto.fromObject(dynamic data) {
    return switch (data) {
      final int v => UpdateCountdownDto(countdown: v),
      final num v => UpdateCountdownDto(countdown: v.toInt()),
      _ => throw FormatException('UpdateCountdown payload', data),
    };
  }

  Map<String, dynamic> toJson() => _$UpdateCountdownDtoToJson(this);
}

@JsonSerializable()
class UpdateStartingCountdownDto {
  final int countdown;

  const UpdateStartingCountdownDto({required this.countdown});

  factory UpdateStartingCountdownDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateStartingCountdownDtoFromJson(json);

  factory UpdateStartingCountdownDto.fromObject(dynamic data) {
    if (data is int) return UpdateStartingCountdownDto(countdown: data);
    if (data is num) return UpdateStartingCountdownDto(countdown: data.toInt());
    throw FormatException('UpdateStartingCountdown payload', data);
  }

  Map<String, dynamic> toJson() => _$UpdateStartingCountdownDtoToJson(this);
}

@JsonSerializable()
class UpdateScoreDto {
  final String winnerId;

  const UpdateScoreDto({required this.winnerId});

  factory UpdateScoreDto.fromJson(Map<String, dynamic> json) =>
      _$UpdateScoreDtoFromJson(json);

  factory UpdateScoreDto.fromObject(dynamic data) => UpdateScoreDto(
    winnerId: _parseSingleStringSocketEvent(data, mapKey: 'winnerId'),
  );

  Map<String, dynamic> toJson() => _$UpdateScoreDtoToJson(this);
}

@JsonSerializable()
class FinishGameDto {
  final String winnerId;

  const FinishGameDto({required this.winnerId});

  factory FinishGameDto.fromJson(Map<String, dynamic> json) =>
      _$FinishGameDtoFromJson(json);

  factory FinishGameDto.fromObject(dynamic data) => FinishGameDto(
    winnerId: _parseSingleStringSocketEvent(data, mapKey: 'winnerId'),
  );

  Map<String, dynamic> toJson() => _$FinishGameDtoToJson(this);
}

@JsonSerializable()
class GameCanceledDto {
  final String playerId;

  const GameCanceledDto({required this.playerId});

  factory GameCanceledDto.fromJson(Map<String, dynamic> json) =>
      _$GameCanceledDtoFromJson(json);

  factory GameCanceledDto.fromObject(dynamic data) =>
      GameCanceledDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$GameCanceledDtoToJson(this);
}

class GameAbandonedDto {
  const GameAbandonedDto();

  factory GameAbandonedDto.fromObject(dynamic _) => const GameAbandonedDto();
}

@JsonSerializable()
class PlayerAbandonedDto {
  final String playerId;

  const PlayerAbandonedDto({required this.playerId});

  factory PlayerAbandonedDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerAbandonedDtoFromJson(json);

  factory PlayerAbandonedDto.fromObject(dynamic data) => PlayerAbandonedDto(
    playerId: _parseSingleStringSocketEvent(data, mapKey: 'playerId'),
  );

  Map<String, dynamic> toJson() => _$PlayerAbandonedDtoToJson(this);
}

@JsonSerializable()
class OrganizatorChangedDto {
  @JsonKey(name: 'newhostId')
  final String newHostId;

  const OrganizatorChangedDto({required this.newHostId});

  factory OrganizatorChangedDto.fromJson(Map<String, dynamic> json) =>
      _$OrganizatorChangedDtoFromJson(json);

  factory OrganizatorChangedDto.fromObject(dynamic data) =>
      OrganizatorChangedDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$OrganizatorChangedDtoToJson(this);
}

@JsonSerializable()
class DoorToggledDto {
  final int x;
  final int y;

  const DoorToggledDto({required this.x, required this.y});

  factory DoorToggledDto.fromJson(Map<String, dynamic> json) =>
      _$DoorToggledDtoFromJson(json);

  factory DoorToggledDto.fromObject(dynamic data) =>
      DoorToggledDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$DoorToggledDtoToJson(this);
}

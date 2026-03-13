// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_events_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ToggleDoorCommandDto _$ToggleDoorCommandDtoFromJson(
  Map<String, dynamic> json,
) => ToggleDoorCommandDto(
  roomId: json['roomId'] as String,
  x: (json['x'] as num).toInt(),
  y: (json['y'] as num).toInt(),
);

Map<String, dynamic> _$ToggleDoorCommandDtoToJson(
  ToggleDoorCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'x': instance.x,
  'y': instance.y,
};

SpawnedPlayerDto _$SpawnedPlayerDtoFromJson(
  Map<String, dynamic> json,
) => SpawnedPlayerDto(
  id: json['id'] as String,
  name: json['name'] as String,
  characterType: const AvatarToCharacterTypeConverter().fromJson(
    json['avatar'] as Map<String, dynamic>,
  ),
  color: const BoardCharacterColorConverter().fromJson(json['color'] as String),
  movementPoints: (json['movementPoints'] as num).toInt(),
  actionPoints: (json['actionPoints'] as num).toInt(),
  spawnPoint: GameBoardPositionDto.fromJson(
    json['spawnPoint'] as Map<String, dynamic>,
  ),
  inventory: (json['inventory'] as List<dynamic>)
      .map((e) => GameItemDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  stats: const StatTypeMapConverter().fromJson(
    json['stats'] as Map<String, dynamic>,
  ),
  diceChoice: const StatTypeConverter().fromJson(json['d6Choice'] as String),
  d4Choice: const StatTypeConverter().fromJson(json['d4Choice'] as String),
  isVirtual: json['isVirtual'] as bool? ?? false,
  team: (json['team'] as num).toInt(),
);

Map<String, dynamic> _$SpawnedPlayerDtoToJson(SpawnedPlayerDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': const AvatarToCharacterTypeConverter().toJson(
        instance.characterType,
      ),
      'color': const BoardCharacterColorConverter().toJson(instance.color),
      'movementPoints': instance.movementPoints,
      'actionPoints': instance.actionPoints,
      'spawnPoint': instance.spawnPoint.toJson(),
      'inventory': instance.inventory.map((e) => e.toJson()).toList(),
      'stats': const StatTypeMapConverter().toJson(instance.stats),
      'd6Choice': const StatTypeConverter().toJson(instance.diceChoice),
      'd4Choice': const StatTypeConverter().toJson(instance.d4Choice),
      'isVirtual': instance.isVirtual,
      'team': instance.team,
    };

PlayerSpawnedDto _$PlayerSpawnedDtoFromJson(Map<String, dynamic> json) =>
    PlayerSpawnedDto(
      players: (json['players'] as List<dynamic>)
          .map((e) => SpawnedPlayerDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlayerSpawnedDtoToJson(PlayerSpawnedDto instance) =>
    <String, dynamic>{
      'players': instance.players.map((e) => e.toJson()).toList(),
    };

TurnStartingDto _$TurnStartingDtoFromJson(Map<String, dynamic> json) =>
    TurnStartingDto(
      nextPlayerId: json['nextPlayerId'] as String,
      startTime: (json['startTime'] as num).toInt(),
      nextPlayerMovementPoints: (json['nextPlayerMovementPoints'] as num)
          .toInt(),
      nextPlayerActionPoints: (json['nextPlayerActionPoints'] as num?)?.toInt(),
      isNextPlayerVirtual: json['isNextPlayerVirtual'] as bool? ?? false,
    );

Map<String, dynamic> _$TurnStartingDtoToJson(TurnStartingDto instance) =>
    <String, dynamic>{
      'nextPlayerId': instance.nextPlayerId,
      'startTime': instance.startTime,
      'nextPlayerMovementPoints': instance.nextPlayerMovementPoints,
      'nextPlayerActionPoints': instance.nextPlayerActionPoints,
      'isNextPlayerVirtual': instance.isNextPlayerVirtual,
    };

UpdateCountdownDto _$UpdateCountdownDtoFromJson(Map<String, dynamic> json) =>
    UpdateCountdownDto(countdown: (json['countdown'] as num).toInt());

Map<String, dynamic> _$UpdateCountdownDtoToJson(UpdateCountdownDto instance) =>
    <String, dynamic>{'countdown': instance.countdown};

UpdateStartingCountdownDto _$UpdateStartingCountdownDtoFromJson(
  Map<String, dynamic> json,
) => UpdateStartingCountdownDto(countdown: (json['countdown'] as num).toInt());

Map<String, dynamic> _$UpdateStartingCountdownDtoToJson(
  UpdateStartingCountdownDto instance,
) => <String, dynamic>{'countdown': instance.countdown};

UpdateScoreDto _$UpdateScoreDtoFromJson(Map<String, dynamic> json) =>
    UpdateScoreDto(winnerId: json['winnerId'] as String);

Map<String, dynamic> _$UpdateScoreDtoToJson(UpdateScoreDto instance) =>
    <String, dynamic>{'winnerId': instance.winnerId};

FinishGameDto _$FinishGameDtoFromJson(Map<String, dynamic> json) =>
    FinishGameDto(winnerId: json['winnerId'] as String);

Map<String, dynamic> _$FinishGameDtoToJson(FinishGameDto instance) =>
    <String, dynamic>{'winnerId': instance.winnerId};

GameCanceledDto _$GameCanceledDtoFromJson(Map<String, dynamic> json) =>
    GameCanceledDto(playerId: json['playerId'] as String);

Map<String, dynamic> _$GameCanceledDtoToJson(GameCanceledDto instance) =>
    <String, dynamic>{'playerId': instance.playerId};

PlayerAbandonedDto _$PlayerAbandonedDtoFromJson(Map<String, dynamic> json) =>
    PlayerAbandonedDto(playerId: json['playerId'] as String);

Map<String, dynamic> _$PlayerAbandonedDtoToJson(PlayerAbandonedDto instance) =>
    <String, dynamic>{'playerId': instance.playerId};

OrganizatorChangedDto _$OrganizatorChangedDtoFromJson(
  Map<String, dynamic> json,
) => OrganizatorChangedDto(newHostId: json['newhostId'] as String);

Map<String, dynamic> _$OrganizatorChangedDtoToJson(
  OrganizatorChangedDto instance,
) => <String, dynamic>{'newhostId': instance.newHostId};

DoorToggledDto _$DoorToggledDtoFromJson(Map<String, dynamic> json) =>
    DoorToggledDto(
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
    );

Map<String, dynamic> _$DoorToggledDtoToJson(DoorToggledDto instance) =>
    <String, dynamic>{'x': instance.x, 'y': instance.y};

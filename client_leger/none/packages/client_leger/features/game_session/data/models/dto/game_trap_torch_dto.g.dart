// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_trap_torch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrapPendingDto _$TrapPendingDtoFromJson(Map<String, dynamic> json) =>
    TrapPendingDto(
      roomId: json['roomId'] as String,
      playerId: json['playerId'] as String,
      canAvoid: _readBool(json['canAvoid']),
    );

Map<String, dynamic> _$TrapPendingDtoToJson(TrapPendingDto instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'playerId': instance.playerId,
      'canAvoid': instance.canAvoid,
    };

TrapResultDto _$TrapResultDtoFromJson(Map<String, dynamic> json) =>
    TrapResultDto(
      roomId: json['roomId'] as String,
      playerId: json['playerId'] as String,
      choice: json['choice'] as String?,
      remainingMovementPoints: _readInt(json['remainingMovementPoints']),
      activated: _readBool(json['activated']),
    );

Map<String, dynamic> _$TrapResultDtoToJson(TrapResultDto instance) =>
    <String, dynamic>{
      'roomId': instance.roomId,
      'playerId': instance.playerId,
      'choice': instance.choice,
      'remainingMovementPoints': instance.remainingMovementPoints,
      'activated': instance.activated,
    };

TrapChoiceCommandDto _$TrapChoiceCommandDtoFromJson(
  Map<String, dynamic> json,
) => TrapChoiceCommandDto(
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String,
  choice: json['choice'] as String,
);

Map<String, dynamic> _$TrapChoiceCommandDtoToJson(
  TrapChoiceCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'choice': instance.choice,
};

GameServerStatValueDto _$GameServerStatValueDtoFromJson(
  Map<String, dynamic> json,
) => GameServerStatValueDto(value: _readInt(json['value']));

Map<String, dynamic> _$GameServerStatValueDtoToJson(
  GameServerStatValueDto instance,
) => <String, dynamic>{'value': instance.value};

GameServerPlayerTorchStatsDto _$GameServerPlayerTorchStatsDtoFromJson(
  Map<String, dynamic> json,
) => GameServerPlayerTorchStatsDto(
  attack: json['attack'] == null
      ? null
      : GameServerStatValueDto.fromJson(json['attack'] as Map<String, dynamic>),
  defense: json['defense'] == null
      ? null
      : GameServerStatValueDto.fromJson(
          json['defense'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$GameServerPlayerTorchStatsDtoToJson(
  GameServerPlayerTorchStatsDto instance,
) => <String, dynamic>{
  'attack': instance.attack?.toJson(),
  'defense': instance.defense?.toJson(),
};

TorchIlluminationPlayerDto _$TorchIlluminationPlayerDtoFromJson(
  Map<String, dynamic> json,
) => TorchIlluminationPlayerDto(
  id: json['id'] as String,
  stats: json['stats'] == null
      ? null
      : GameServerPlayerTorchStatsDto.fromJson(
          json['stats'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$TorchIlluminationPlayerDtoToJson(
  TorchIlluminationPlayerDto instance,
) => <String, dynamic>{'id': instance.id, 'stats': instance.stats?.toJson()};

TorchIlluminationUpdateDto _$TorchIlluminationUpdateDtoFromJson(
  Map<String, dynamic> json,
) => TorchIlluminationUpdateDto(
  roomId: json['roomId'] as String,
  illuminatedCells:
      (json['illuminatedCells'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      [],
  players:
      (json['players'] as List<dynamic>?)
          ?.map(
            (e) =>
                TorchIlluminationPlayerDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      [],
);

Map<String, dynamic> _$TorchIlluminationUpdateDtoToJson(
  TorchIlluminationUpdateDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'illuminatedCells': instance.illuminatedCells,
  'players': instance.players.map((e) => e.toJson()).toList(),
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_player_movement_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerGetMovementsCommandDto _$PlayerGetMovementsCommandDtoFromJson(
  Map<String, dynamic> json,
) => PlayerGetMovementsCommandDto(
  roomId: json['roomId'] as String,
  hasBoots: json['hasBoots'] as bool,
);

Map<String, dynamic> _$PlayerGetMovementsCommandDtoToJson(
  PlayerGetMovementsCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'hasBoots': instance.hasBoots,
};

PlayerMovedCommandDto _$PlayerMovedCommandDtoFromJson(
  Map<String, dynamic> json,
) => PlayerMovedCommandDto(
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String,
  selectedPath: (json['selectedPath'] as List<dynamic>)
      .map((e) => GameBoardPositionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PlayerMovedCommandDtoToJson(
  PlayerMovedCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'selectedPath': instance.selectedPath.map((e) => e.toJson()).toList(),
};

PlayerTeleportedCommandDto _$PlayerTeleportedCommandDtoFromJson(
  Map<String, dynamic> json,
) => PlayerTeleportedCommandDto(
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String,
  destination: GameBoardPositionDto.fromJson(
    json['destination'] as Map<String, dynamic>,
  ),
  hasCamouflage: json['hasCamouflage'] as bool,
);

Map<String, dynamic> _$PlayerTeleportedCommandDtoToJson(
  PlayerTeleportedCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'destination': instance.destination.toJson(),
  'hasCamouflage': instance.hasCamouflage,
};

SynchronizeMovementCommandDto _$SynchronizeMovementCommandDtoFromJson(
  Map<String, dynamic> json,
) => SynchronizeMovementCommandDto(
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String,
  destination: GameBoardPositionDto.fromJson(
    json['destination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SynchronizeMovementCommandDtoToJson(
  SynchronizeMovementCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'destination': instance.destination.toJson(),
};

PlayerMovedDto _$PlayerMovedDtoFromJson(Map<String, dynamic> json) =>
    PlayerMovedDto(
      playerId: json['playerId'] as String,
      movementPoints: (json['movementPoints'] as num).toInt(),
      selectedPath: (json['selectedPath'] as List<dynamic>)
          .map((e) => GameBoardPositionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PlayerMovedDtoToJson(PlayerMovedDto instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'movementPoints': instance.movementPoints,
      'selectedPath': instance.selectedPath.map((e) => e.toJson()).toList(),
    };

PlayerTeleportedDto _$PlayerTeleportedDtoFromJson(Map<String, dynamic> json) =>
    PlayerTeleportedDto(
      playerId: json['playerId'] as String,
      destination: GameBoardPositionDto.fromJson(
        json['destination'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PlayerTeleportedDtoToJson(
  PlayerTeleportedDto instance,
) => <String, dynamic>{
  'playerId': instance.playerId,
  'destination': instance.destination.toJson(),
};

VirtualPlayerMovedDto _$VirtualPlayerMovedDtoFromJson(
  Map<String, dynamic> json,
) => VirtualPlayerMovedDto(
  playerId: json['playerId'] as String,
  path: (json['path'] as List<dynamic>)
      .map((e) => GameBoardPositionDto.fromJson(e as Map<String, dynamic>))
      .toList(),
  remainingMovementPoints: (json['remainingMovementPoints'] as num).toInt(),
  opponentPlayerId: json['opponentPlayerId'] as String?,
);

Map<String, dynamic> _$VirtualPlayerMovedDtoToJson(
  VirtualPlayerMovedDto instance,
) => <String, dynamic>{
  'playerId': instance.playerId,
  'path': instance.path.map((e) => e.toJson()).toList(),
  'remainingMovementPoints': instance.remainingMovementPoints,
  'opponentPlayerId': instance.opponentPlayerId,
};

SynchronizeMovementDto _$SynchronizeMovementDtoFromJson(
  Map<String, dynamic> json,
) => SynchronizeMovementDto(
  playerId: json['playerId'] as String,
  destination: GameBoardPositionDto.fromJson(
    json['destination'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$SynchronizeMovementDtoToJson(
  SynchronizeMovementDto instance,
) => <String, dynamic>{
  'playerId': instance.playerId,
  'destination': instance.destination.toJson(),
};

import 'package:json_annotation/json_annotation.dart';

import 'game_board_position_dto.dart';

part 'game_player_movement_dto.g.dart';

@JsonSerializable()
class PlayerGetMovementsCommandDto {
  final String roomId;
  final bool hasBoots;

  const PlayerGetMovementsCommandDto({
    required this.roomId,
    required this.hasBoots,
  });

  factory PlayerGetMovementsCommandDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerGetMovementsCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerGetMovementsCommandDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlayerMovedCommandDto {
  final String roomId;
  final String playerId;
  final List<GameBoardPositionDto> selectedPath;

  const PlayerMovedCommandDto({
    required this.roomId,
    required this.playerId,
    required this.selectedPath,
  });

  factory PlayerMovedCommandDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerMovedCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerMovedCommandDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlayerTeleportedCommandDto {
  final String roomId;
  final String playerId;
  final GameBoardPositionDto destination;
  final bool hasCamouflage;

  const PlayerTeleportedCommandDto({
    required this.roomId,
    required this.playerId,
    required this.destination,
    required this.hasCamouflage,
  });

  factory PlayerTeleportedCommandDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerTeleportedCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerTeleportedCommandDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SynchronizeMovementCommandDto {
  final String roomId;
  final String playerId;
  final GameBoardPositionDto destination;

  const SynchronizeMovementCommandDto({
    required this.roomId,
    required this.playerId,
    required this.destination,
  });

  factory SynchronizeMovementCommandDto.fromJson(Map<String, dynamic> json) =>
      _$SynchronizeMovementCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SynchronizeMovementCommandDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlayerMovedDto {
  final String playerId;
  final int movementPoints;
  final List<GameBoardPositionDto> selectedPath;

  const PlayerMovedDto({
    required this.playerId,
    required this.movementPoints,
    required this.selectedPath,
  });

  factory PlayerMovedDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerMovedDtoFromJson(json);

  factory PlayerMovedDto.fromObject(dynamic data) =>
      PlayerMovedDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PlayerMovedDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class PlayerTeleportedDto {
  final String playerId;
  final GameBoardPositionDto destination;

  const PlayerTeleportedDto({
    required this.playerId,
    required this.destination,
  });

  factory PlayerTeleportedDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerTeleportedDtoFromJson(json);

  factory PlayerTeleportedDto.fromObject(dynamic data) =>
      PlayerTeleportedDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$PlayerTeleportedDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class VirtualPlayerMovedDto {
  final String playerId;
  final List<GameBoardPositionDto> path;
  final int remainingMovementPoints;
  final String? opponentPlayerId;

  const VirtualPlayerMovedDto({
    required this.playerId,
    required this.path,
    required this.remainingMovementPoints,
    this.opponentPlayerId,
  });

  factory VirtualPlayerMovedDto.fromJson(Map<String, dynamic> json) =>
      _$VirtualPlayerMovedDtoFromJson(json);

  factory VirtualPlayerMovedDto.fromObject(dynamic data) {
    final payloadMap = data as Map<String, dynamic>;
    final pathRaw = payloadMap['path'];
    final rawPathList = pathRaw is List ? pathRaw : const [];
    final coordsList = rawPathList.map((item) {
      if (item is Map && item.containsKey('coord')) {
        return item['coord'];
      }
      return item;
    }).toList();
    final opponentId = payloadMap['opponentPlayerId'];
    final rawRemainingMovementPoints = payloadMap['remainingMovementPoints'];
    final remainingMovementPoints = switch (rawRemainingMovementPoints) {
      final int value => value,
      final num value => value.toInt(),
      final String value => int.tryParse(value) ?? 0,
      _ => 0,
    };
    return VirtualPlayerMovedDto(
      playerId: payloadMap['playerId'] as String? ?? '',
      path: coordsList.map(GameBoardPositionDto.fromDynamic).toList(),
      remainingMovementPoints: remainingMovementPoints,
      opponentPlayerId: opponentId is String ? opponentId : null,
    );
  }

  Map<String, dynamic> toJson() => _$VirtualPlayerMovedDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SynchronizeMovementDto {
  final String playerId;
  final GameBoardPositionDto destination;

  const SynchronizeMovementDto({
    required this.playerId,
    required this.destination,
  });

  factory SynchronizeMovementDto.fromJson(Map<String, dynamic> json) =>
      _$SynchronizeMovementDtoFromJson(json);

  factory SynchronizeMovementDto.fromObject(dynamic data) =>
      SynchronizeMovementDto.fromJson(data as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$SynchronizeMovementDtoToJson(this);
}

class ReachablePathsResponseDto {
  final List<(GameBoardPositionDto, List<GameBoardPositionDto>)> paths;

  const ReachablePathsResponseDto({required this.paths});

  factory ReachablePathsResponseDto.fromObject(dynamic data) {
    final payloadMap = data as Map<String, dynamic>;
    final rawPathsList = payloadMap['paths'] as List;
    final paths = rawPathsList.map((raw) {
      final pair = raw as List;
      return (
        GameBoardPositionDto.fromDynamic(pair[0]),
        (pair[1] as List).map(GameBoardPositionDto.fromDynamic).toList(),
      );
    }).toList();
    return ReachablePathsResponseDto(paths: paths);
  }
}

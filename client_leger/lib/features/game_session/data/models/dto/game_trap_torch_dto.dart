import 'package:json_annotation/json_annotation.dart';

part 'game_trap_torch_dto.g.dart';

int _readInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

bool _readBool(dynamic value) {
  if (value is bool) return value;
  return false;
}

@JsonSerializable()
class TrapPendingDto {
  final String roomId;
  final String playerId;
  @JsonKey(fromJson: _readBool)
  final bool canAvoid;

  const TrapPendingDto({
    required this.roomId,
    required this.playerId,
    required this.canAvoid,
  });

  factory TrapPendingDto.fromJson(Map<String, dynamic> json) =>
      _$TrapPendingDtoFromJson(json);

  factory TrapPendingDto.fromObject(dynamic data) =>
      TrapPendingDto.fromJson(Map<String, dynamic>.from(data as Map));

  Map<String, dynamic> toJson() => _$TrapPendingDtoToJson(this);
}

@JsonSerializable()
class TrapResultDto {
  final String roomId;
  final String playerId;
  final String? choice;
  @JsonKey(fromJson: _readInt)
  final int remainingMovementPoints;
  @JsonKey(fromJson: _readBool)
  final bool activated;

  const TrapResultDto({
    required this.roomId,
    required this.playerId,
    this.choice,
    required this.remainingMovementPoints,
    required this.activated,
  });

  factory TrapResultDto.fromJson(Map<String, dynamic> json) =>
      _$TrapResultDtoFromJson(json);

  factory TrapResultDto.fromObject(dynamic data) =>
      TrapResultDto.fromJson(Map<String, dynamic>.from(data as Map));

  Map<String, dynamic> toJson() => _$TrapResultDtoToJson(this);
}

@JsonSerializable()
class TrapChoiceCommandDto {
  final String roomId;
  final String playerId;
  final String choice;

  const TrapChoiceCommandDto({
    required this.roomId,
    required this.playerId,
    required this.choice,
  });

  factory TrapChoiceCommandDto.fromJson(Map<String, dynamic> json) =>
      _$TrapChoiceCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TrapChoiceCommandDtoToJson(this);
}

@JsonSerializable()
class GameServerStatValueDto {
  @JsonKey(fromJson: _readInt)
  final int value;

  const GameServerStatValueDto({required this.value});

  factory GameServerStatValueDto.fromJson(Map<String, dynamic> json) =>
      _$GameServerStatValueDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameServerStatValueDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GameServerPlayerTorchStatsDto {
  final GameServerStatValueDto? attack;
  final GameServerStatValueDto? defense;

  const GameServerPlayerTorchStatsDto({this.attack, this.defense});

  factory GameServerPlayerTorchStatsDto.fromJson(Map<String, dynamic> json) =>
      _$GameServerPlayerTorchStatsDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GameServerPlayerTorchStatsDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TorchIlluminationPlayerDto {
  final String id;
  final GameServerPlayerTorchStatsDto? stats;

  const TorchIlluminationPlayerDto({required this.id, this.stats});

  factory TorchIlluminationPlayerDto.fromJson(Map<String, dynamic> json) =>
      _$TorchIlluminationPlayerDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TorchIlluminationPlayerDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TorchIlluminationUpdateDto {
  final String roomId;
  @JsonKey(defaultValue: <String>[])
  final List<String> illuminatedCells;
  @JsonKey(defaultValue: <TorchIlluminationPlayerDto>[])
  final List<TorchIlluminationPlayerDto> players;

  const TorchIlluminationUpdateDto({
    required this.roomId,
    required this.illuminatedCells,
    required this.players,
  });

  factory TorchIlluminationUpdateDto.fromJson(Map<String, dynamic> json) =>
      _$TorchIlluminationUpdateDtoFromJson(json);

  factory TorchIlluminationUpdateDto.fromObject(dynamic data) =>
      TorchIlluminationUpdateDto.fromJson(
        Map<String, dynamic>.from(data as Map),
      );

  Map<String, dynamic> toJson() => _$TorchIlluminationUpdateDtoToJson(this);
}

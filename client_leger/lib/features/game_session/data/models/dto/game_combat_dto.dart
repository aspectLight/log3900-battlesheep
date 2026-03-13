import 'package:json_annotation/json_annotation.dart';

part 'game_combat_dto.g.dart';

@JsonSerializable()
class StartCombatCommandDto {
  final String roomId;
  final String opponentId;

  const StartCombatCommandDto({required this.roomId, required this.opponentId});

  factory StartCombatCommandDto.fromJson(Map<String, dynamic> json) =>
      _$StartCombatCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StartCombatCommandDtoToJson(this);
}

@JsonSerializable()
class StartVirtualCombatCommandDto {
  final String roomId;
  final String playerId;
  final String opponentId;

  const StartVirtualCombatCommandDto({
    required this.roomId,
    required this.playerId,
    required this.opponentId,
  });

  factory StartVirtualCombatCommandDto.fromJson(Map<String, dynamic> json) =>
      _$StartVirtualCombatCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StartVirtualCombatCommandDtoToJson(this);
}

@JsonSerializable()
class AttackCommandDto {
  final String roomId;

  const AttackCommandDto({required this.roomId});

  factory AttackCommandDto.fromJson(Map<String, dynamic> json) =>
      _$AttackCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AttackCommandDtoToJson(this);
}

@JsonSerializable()
class FlightAttemptCommandDto {
  final String roomId;

  const FlightAttemptCommandDto({required this.roomId});

  factory FlightAttemptCommandDto.fromJson(Map<String, dynamic> json) =>
      _$FlightAttemptCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FlightAttemptCommandDtoToJson(this);
}

@JsonSerializable()
class AttackResultDto {
  final bool isAttackSuccess;
  final int opponentHealthPoints;
  final int attackValue;
  final int defenseValue;

  const AttackResultDto({
    required this.isAttackSuccess,
    required this.opponentHealthPoints,
    required this.attackValue,
    required this.defenseValue,
  });

  factory AttackResultDto.fromJson(Map<String, dynamic> json) =>
      _$AttackResultDtoFromJson(json);

  factory AttackResultDto.fromObject(Map<String, dynamic> data) =>
      AttackResultDto.fromJson(data);

  Map<String, dynamic> toJson() => _$AttackResultDtoToJson(this);
}

@JsonSerializable()
class FlightAttemptResultDto {
  final bool isSuccess;
  final int attackerEvasionPoints;

  const FlightAttemptResultDto({
    required this.isSuccess,
    required this.attackerEvasionPoints,
  });

  factory FlightAttemptResultDto.fromJson(Map<String, dynamic> json) =>
      _$FlightAttemptResultDtoFromJson(json);

  factory FlightAttemptResultDto.fromObject(Map<String, dynamic> data) =>
      FlightAttemptResultDto.fromJson(data);

  Map<String, dynamic> toJson() => _$FlightAttemptResultDtoToJson(this);
}

@JsonSerializable()
class CombatTurnStartedDto {
  final String combatRoomId;
  final String currentPlayerId;
  final String currentOpponentId;
  final String attackerId;
  final String defenderId;

  const CombatTurnStartedDto({
    required this.combatRoomId,
    required this.currentPlayerId,
    required this.currentOpponentId,
    required this.attackerId,
    required this.defenderId,
  });

  factory CombatTurnStartedDto.fromJson(Map<String, dynamic> json) =>
      _$CombatTurnStartedDtoFromJson(json);

  factory CombatTurnStartedDto.fromObject(Map<String, dynamic> data) =>
      CombatTurnStartedDto.fromJson(data);

  Map<String, dynamic> toJson() => _$CombatTurnStartedDtoToJson(this);
}

@JsonSerializable()
class EndCombatResultDto {
  final String winnerId;
  final String loserId;
  final bool isByFlight;

  const EndCombatResultDto({
    required this.winnerId,
    required this.loserId,
    required this.isByFlight,
  });

  factory EndCombatResultDto.fromJson(Map<String, dynamic> json) =>
      _$EndCombatResultDtoFromJson(json);

  factory EndCombatResultDto.fromObject(dynamic data) {
    if (data is List && data.length >= 3) {
      return EndCombatResultDto(
        winnerId: data[0] as String,
        loserId: data[1] as String,
        isByFlight: data[2] as bool,
      );
    }
    if (data is Map<String, dynamic>) {
      return EndCombatResultDto.fromJson(data);
    }
    final winnerId = data?.toString() ?? '';
    return EndCombatResultDto(
      winnerId: winnerId,
      loserId: '',
      isByFlight: false,
    );
  }

  Map<String, dynamic> toJson() => _$EndCombatResultDtoToJson(this);
}

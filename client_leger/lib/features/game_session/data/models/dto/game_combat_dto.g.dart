// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_combat_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StartCombatCommandDto _$StartCombatCommandDtoFromJson(
  Map<String, dynamic> json,
) => StartCombatCommandDto(
  roomId: json['roomId'] as String,
  opponentId: json['opponentId'] as String,
);

Map<String, dynamic> _$StartCombatCommandDtoToJson(
  StartCombatCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'opponentId': instance.opponentId,
};

StartVirtualCombatCommandDto _$StartVirtualCombatCommandDtoFromJson(
  Map<String, dynamic> json,
) => StartVirtualCombatCommandDto(
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String,
  opponentId: json['opponentId'] as String,
);

Map<String, dynamic> _$StartVirtualCombatCommandDtoToJson(
  StartVirtualCombatCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'opponentId': instance.opponentId,
};

AttackCommandDto _$AttackCommandDtoFromJson(Map<String, dynamic> json) =>
    AttackCommandDto(roomId: json['roomId'] as String);

Map<String, dynamic> _$AttackCommandDtoToJson(AttackCommandDto instance) =>
    <String, dynamic>{'roomId': instance.roomId};

FlightAttemptCommandDto _$FlightAttemptCommandDtoFromJson(
  Map<String, dynamic> json,
) => FlightAttemptCommandDto(roomId: json['roomId'] as String);

Map<String, dynamic> _$FlightAttemptCommandDtoToJson(
  FlightAttemptCommandDto instance,
) => <String, dynamic>{'roomId': instance.roomId};

AttackResultDto _$AttackResultDtoFromJson(Map<String, dynamic> json) =>
    AttackResultDto(
      isAttackSuccess: json['isAttackSuccess'] as bool,
      opponentHealthPoints: (json['opponentHealthPoints'] as num).toInt(),
      attackValue: (json['attackValue'] as num).toInt(),
      defenseValue: (json['defenseValue'] as num).toInt(),
    );

Map<String, dynamic> _$AttackResultDtoToJson(AttackResultDto instance) =>
    <String, dynamic>{
      'isAttackSuccess': instance.isAttackSuccess,
      'opponentHealthPoints': instance.opponentHealthPoints,
      'attackValue': instance.attackValue,
      'defenseValue': instance.defenseValue,
    };

FlightAttemptResultDto _$FlightAttemptResultDtoFromJson(
  Map<String, dynamic> json,
) => FlightAttemptResultDto(
  isSuccess: json['isSuccess'] as bool,
  attackerEvasionPoints: (json['attackerEvasionPoints'] as num).toInt(),
);

Map<String, dynamic> _$FlightAttemptResultDtoToJson(
  FlightAttemptResultDto instance,
) => <String, dynamic>{
  'isSuccess': instance.isSuccess,
  'attackerEvasionPoints': instance.attackerEvasionPoints,
};

CombatTurnStartedDto _$CombatTurnStartedDtoFromJson(
  Map<String, dynamic> json,
) => CombatTurnStartedDto(
  combatRoomId: json['combatRoomId'] as String,
  currentPlayerId: json['currentPlayerId'] as String,
  currentOpponentId: json['currentOpponentId'] as String,
  attackerId: json['attackerId'] as String,
  defenderId: json['defenderId'] as String,
);

Map<String, dynamic> _$CombatTurnStartedDtoToJson(
  CombatTurnStartedDto instance,
) => <String, dynamic>{
  'combatRoomId': instance.combatRoomId,
  'currentPlayerId': instance.currentPlayerId,
  'currentOpponentId': instance.currentOpponentId,
  'attackerId': instance.attackerId,
  'defenderId': instance.defenderId,
};

EndCombatResultDto _$EndCombatResultDtoFromJson(Map<String, dynamic> json) =>
    EndCombatResultDto(
      winnerId: json['winnerId'] as String,
      loserId: json['loserId'] as String,
      isByFlight: json['isByFlight'] as bool,
    );

Map<String, dynamic> _$EndCombatResultDtoToJson(EndCombatResultDto instance) =>
    <String, dynamic>{
      'winnerId': instance.winnerId,
      'loserId': instance.loserId,
      'isByFlight': instance.isByFlight,
    };

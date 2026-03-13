// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_actions_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForwardTurnCommandDto _$ForwardTurnCommandDtoFromJson(
  Map<String, dynamic> json,
) => ForwardTurnCommandDto(roomId: json['roomId'] as String);

Map<String, dynamic> _$ForwardTurnCommandDtoToJson(
  ForwardTurnCommandDto instance,
) => <String, dynamic>{'roomId': instance.roomId};

AbandonGameCommandDto _$AbandonGameCommandDtoFromJson(
  Map<String, dynamic> json,
) => AbandonGameCommandDto(roomId: json['roomId'] as String);

Map<String, dynamic> _$AbandonGameCommandDtoToJson(
  AbandonGameCommandDto instance,
) => <String, dynamic>{'roomId': instance.roomId};

QuitEndGameCommandDto _$QuitEndGameCommandDtoFromJson(
  Map<String, dynamic> json,
) => QuitEndGameCommandDto(roomId: json['roomId'] as String);

Map<String, dynamic> _$QuitEndGameCommandDtoToJson(
  QuitEndGameCommandDto instance,
) => <String, dynamic>{'roomId': instance.roomId};

VirtualPlayerTurnCommandDto _$VirtualPlayerTurnCommandDtoFromJson(
  Map<String, dynamic> json,
) => VirtualPlayerTurnCommandDto(
  roomId: json['roomId'] as String,
  playerId: json['playerId'] as String,
  isCTF: json['isCTF'] as bool,
  skipTimeout: json['skipTimeout'] as bool,
);

Map<String, dynamic> _$VirtualPlayerTurnCommandDtoToJson(
  VirtualPlayerTurnCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'playerId': instance.playerId,
  'isCTF': instance.isCTF,
  'skipTimeout': instance.skipTimeout,
};

FinishGameCommandDto _$FinishGameCommandDtoFromJson(
  Map<String, dynamic> json,
) => FinishGameCommandDto(
  roomId: json['roomId'] as String,
  winnerId: json['winnerId'] as String,
);

Map<String, dynamic> _$FinishGameCommandDtoToJson(
  FinishGameCommandDto instance,
) => <String, dynamic>{
  'roomId': instance.roomId,
  'winnerId': instance.winnerId,
};

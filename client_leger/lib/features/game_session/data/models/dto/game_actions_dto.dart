import 'package:json_annotation/json_annotation.dart';

part 'game_actions_dto.g.dart';

@JsonSerializable()
class ForwardTurnCommandDto {
  final String roomId;

  const ForwardTurnCommandDto({required this.roomId});

  factory ForwardTurnCommandDto.fromJson(Map<String, dynamic> json) =>
      _$ForwardTurnCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ForwardTurnCommandDtoToJson(this);
}

@JsonSerializable()
class AbandonGameCommandDto {
  final String roomId;

  const AbandonGameCommandDto({required this.roomId});

  factory AbandonGameCommandDto.fromJson(Map<String, dynamic> json) =>
      _$AbandonGameCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AbandonGameCommandDtoToJson(this);
}

@JsonSerializable()
class QuitEndGameCommandDto {
  final String roomId;

  const QuitEndGameCommandDto({required this.roomId});

  factory QuitEndGameCommandDto.fromJson(Map<String, dynamic> json) =>
      _$QuitEndGameCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$QuitEndGameCommandDtoToJson(this);
}

@JsonSerializable()
class VirtualPlayerTurnCommandDto {
  final String roomId;
  final String playerId;
  final bool isCTF;
  final bool skipTimeout;

  const VirtualPlayerTurnCommandDto({
    required this.roomId,
    required this.playerId,
    required this.isCTF,
    required this.skipTimeout,
  });

  factory VirtualPlayerTurnCommandDto.fromJson(Map<String, dynamic> json) =>
      _$VirtualPlayerTurnCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VirtualPlayerTurnCommandDtoToJson(this);
}

@JsonSerializable()
class FinishGameCommandDto {
  final String roomId;
  final String winnerId;

  const FinishGameCommandDto({required this.roomId, required this.winnerId});

  factory FinishGameCommandDto.fromJson(Map<String, dynamic> json) =>
      _$FinishGameCommandDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FinishGameCommandDtoToJson(this);
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_action_commands.freezed.dart';

@freezed
class ForwardTurnCommand with _$ForwardTurnCommand {
  const factory ForwardTurnCommand({required String roomId}) =
      _ForwardTurnCommand;
}

@freezed
class AbandonGameCommand with _$AbandonGameCommand {
  const factory AbandonGameCommand({required String roomId}) =
      _AbandonGameCommand;
}

@freezed
class QuitEndGameCommand with _$QuitEndGameCommand {
  const factory QuitEndGameCommand({required String roomId}) = _QuitEndGameCommand;
}

@freezed
class VirtualPlayerTurnCommand with _$VirtualPlayerTurnCommand {
  const factory VirtualPlayerTurnCommand({
    required String roomId,
    required String playerId,
    required bool isCTF,
    required bool skipTimeout,
  }) = _VirtualPlayerTurnCommand;
}

@freezed
class FinishGameCommand with _$FinishGameCommand {
  const factory FinishGameCommand({
    required String roomId,
    required String winnerId,
  }) = _FinishGameCommand;
}

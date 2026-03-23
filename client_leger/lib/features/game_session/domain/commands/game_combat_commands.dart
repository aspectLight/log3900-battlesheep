import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_combat_commands.freezed.dart';

@freezed
class StartCombatCommand with _$StartCombatCommand {
  const factory StartCombatCommand({
    required String roomId,
    required String opponentId,
  }) = _StartCombatCommand;
}

@freezed
class StartVirtualCombatCommand with _$StartVirtualCombatCommand {
  const factory StartVirtualCombatCommand({
    required String roomId,
    required String playerId,
    required String opponentId,
  }) = _StartVirtualCombatCommand;
}

@freezed
class AttackCommand with _$AttackCommand {
  const factory AttackCommand({required String roomId}) = _AttackCommand;
}

@freezed
class FlightAttemptCommand with _$FlightAttemptCommand {
  const factory FlightAttemptCommand({required String roomId}) =
      _FlightAttemptCommand;
}

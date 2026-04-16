import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_turn_state.freezed.dart';

@freezed
class GameTurnState with _$GameTurnState {
  const factory GameTurnState({
    required String currentPlayerId,
    required int turnCountdown,
    required int startCountdown,
    required bool canForwardTurn,
  }) = _GameTurnState;

  const GameTurnState._();

  factory GameTurnState.initial() => const GameTurnState(
    currentPlayerId: '',
    turnCountdown: 0,
    startCountdown: 0,
    canForwardTurn: false,
  );

  bool isCurrentSessionPlayerTurn(String sessionPlayerId) =>
      currentPlayerId == sessionPlayerId;
}

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/exceptions/join_game_session_failure.dart';

part 'join_game_session_state.freezed.dart';

@freezed
sealed class JoinGameSessionState with _$JoinGameSessionState {
  const factory JoinGameSessionState.initial() = JoinGameSessionStateInitial;

  const factory JoinGameSessionState.loading() = JoinGameSessionStateLoading;

  const factory JoinGameSessionState.success() = JoinGameSessionStateSuccess;

  const factory JoinGameSessionState.error(JoinGameSessionFailure failure) =
      JoinGameSessionStateError;
}

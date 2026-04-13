import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/game_info_model.dart';

part 'select_game_session_state.freezed.dart';

@freezed
sealed class SelectGameSessionState with _$SelectGameSessionState {
  const factory SelectGameSessionState.loaded({
    required List<GameModelInfo> games,
    @Default(false) bool isConfirming,
    @Default(false) bool isLoadingGames,
  }) = SelectGameSessionStateLoaded;
}

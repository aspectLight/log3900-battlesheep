import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/enums/game_mode.dart';

part 'select_game_session_events.freezed.dart';

@freezed
sealed class SelectGameSessionEntryAppEvent
    with _$SelectGameSessionEntryAppEvent
    implements AppTransitionEvent {
  const factory SelectGameSessionEntryAppEvent.startSelection() =
      SelectGameSessionStartSelection;
}

@freezed
sealed class SelectGameSessionCompletedAppEvent
    with _$SelectGameSessionCompletedAppEvent
    implements AppTransitionEvent {
  const factory SelectGameSessionCompletedAppEvent.ready() =
      SelectGameSessionReady;
}

@freezed
sealed class SelectGameSessionExitAppEvent
    with _$SelectGameSessionExitAppEvent
    implements AppTransitionEvent {
  const factory SelectGameSessionExitAppEvent.cancelled() =
      SelectGameSessionCancelled;
  const factory SelectGameSessionExitAppEvent.gameSelected({
    required String gameId,
    required String gameName,
    required String gameDescription,
    required GameMode gameMode,
    required int boardSize,
    @Default(0) int entryFee,
    required bool friendsOnly,
  }) = SelectGameSessionGameSelected;
}

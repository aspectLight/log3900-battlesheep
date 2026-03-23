import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../enums/player_leave_reason.dart';
import '../enums/session_end_reason.dart';

part 'game_session_events.freezed.dart';

@freezed
sealed class GameSessionEntryAppEvent
    with _$GameSessionEntryAppEvent
    implements AppTransitionEvent {
  const factory GameSessionEntryAppEvent.startRequested({
    required String roomId,
    required String gameId,
    required String socketId,
    required String gameName,
    required String gameDescription,
  }) = StartGameSessionRequestedCommand;

  const factory GameSessionEntryAppEvent.startConfirmed({
    required String roomId,
    required String gameId,
    required String socketId,
    required bool isHost,
    required String gameRoomHostId,
    required String gameName,
    required String gameDescription,
  }) = GameSessionStartConfirmedEvent;

  const factory GameSessionEntryAppEvent.loaded() = GameSessionLoadedEvent;
}

@freezed
class GameSessionCompletedAppEvent
    with _$GameSessionCompletedAppEvent
    implements AppTransitionEvent {
  const factory GameSessionCompletedAppEvent() =
      _GameSessionCompletedAppEvent;
}

@freezed
sealed class GameSessionExitAppEvent
    with _$GameSessionExitAppEvent
    implements AppTransitionEvent {
  const factory GameSessionExitAppEvent.leaveRequested(PlayerLeaveReason reason) =
      LeaveGameSessionRequestedCommand;

  const factory GameSessionExitAppEvent.sessionTerminated(SessionEndReason reason) =
      SessionTerminatedEvent;

  const factory GameSessionExitAppEvent.gameFinished({
    required String roomId,
    required bool isCTF,
  }) = GameFinishedEvent;
}

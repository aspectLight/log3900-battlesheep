import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../domain/result/join_room_result.dart';

part 'join_game_session_events.freezed.dart';

@freezed
sealed class JoinGameSessionEntryAppEvent
    with _$JoinGameSessionEntryAppEvent
    implements AppTransitionEvent {
  const factory JoinGameSessionEntryAppEvent.joinGameSessionRequested() =
      JoinGameSessionRequested;
}

@freezed
sealed class JoinGameSessionCompletedAppEvent
    with _$JoinGameSessionCompletedAppEvent
    implements AppTransitionEvent {
  const factory JoinGameSessionCompletedAppEvent.ready() = JoinGameSessionReady;
}

@freezed
sealed class JoinGameSessionExitAppEvent
    with _$JoinGameSessionExitAppEvent
    implements AppTransitionEvent {
  const factory JoinGameSessionExitAppEvent.leaveRequested() =
      JoinGameSessionLeaveRequested;
  const factory JoinGameSessionExitAppEvent.joinSucceeded(
    JoinRoomResult result,
  ) = JoinGameSessionJoinSucceeded;
}

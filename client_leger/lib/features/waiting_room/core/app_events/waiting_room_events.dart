import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/enums/waiting_room_leave_reason.dart';
import '../../../../core/models/lobby_room_model.dart';

part 'waiting_room_events.freezed.dart';

@freezed
sealed class WaitingRoomEntryAppEvent
    with _$WaitingRoomEntryAppEvent
    implements AppTransitionEvent {
  const factory WaitingRoomEntryAppEvent.enteredAsHost({
    required String roomId,
    required String hostId,
    required String socketId,
    required String gameName,
    required String gameDescription,
    required int boardSize,
    required bool isCTF,
    @Default(false) bool friendsOnly,
  }) = WaitingRoomEnteredAsHost;
  const factory WaitingRoomEntryAppEvent.enteredAsJoin({
    required String roomId,
    required String hostId,
    required String socketId,
    required String gameName,
    required String gameDescription,
    required LobbyRoomModel initialRoom,
  }) = WaitingRoomEnteredAsJoin;
}

@freezed
sealed class WaitingRoomCompletedAppEvent
    with _$WaitingRoomCompletedAppEvent
    implements AppTransitionEvent {
  const factory WaitingRoomCompletedAppEvent() = WaitingRoomCompleted;
}

@freezed
sealed class WaitingRoomExitAppEvent
    with _$WaitingRoomExitAppEvent
    implements AppTransitionEvent {
  const factory WaitingRoomExitAppEvent.leaveRequested() =
      WaitingRoomLeaveRequested;
  const factory WaitingRoomExitAppEvent.systemLeave(
    WaitingRoomLeaveReason reason,
  ) = WaitingRoomSystemLeave;
}

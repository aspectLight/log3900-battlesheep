import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';

part 'game_history_events.freezed.dart';

@freezed
sealed class GameHistoryEntryAppEvent with _$GameHistoryEntryAppEvent
    implements AppTransitionEvent {
  const factory GameHistoryEntryAppEvent.requested() =
      GameHistoryRequested;
}

@freezed
class GameHistoryCompletedAppEvent
    with _$GameHistoryCompletedAppEvent
    implements AppTransitionEvent {
  const factory GameHistoryCompletedAppEvent() =
      _GameHistoryCompletedAppEvent;
}

@freezed
sealed class GameHistoryExitAppEvent with _$GameHistoryExitAppEvent
    implements AppTransitionEvent {
  const factory GameHistoryExitAppEvent.leaveRequested() =
      GameHistoryLeaveRequested;
}

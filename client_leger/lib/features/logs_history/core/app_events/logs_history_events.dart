import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';

part 'logs_history_events.freezed.dart';

@freezed
sealed class LogsHistoryEntryAppEvent with _$LogsHistoryEntryAppEvent
    implements AppTransitionEvent {
  const factory LogsHistoryEntryAppEvent.requested() =
      LogsHistoryRequested;
}

@freezed
class LogsHistoryCompletedAppEvent
    with _$LogsHistoryCompletedAppEvent
    implements AppTransitionEvent {
  const factory LogsHistoryCompletedAppEvent() =
      _LogsHistoryCompletedAppEvent;
}

@freezed
sealed class LogsHistoryExitAppEvent with _$LogsHistoryExitAppEvent
    implements AppTransitionEvent {
  const factory LogsHistoryExitAppEvent.leaveRequested() =
      LogsHistoryLeaveRequested;
}

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';

part 'discussion_canals_events.freezed.dart';

@freezed
sealed class DiscussionCanalsEntryAppEvent
    with _$DiscussionCanalsEntryAppEvent
    implements AppTransitionEvent {
  const factory DiscussionCanalsEntryAppEvent.discussionCanalsRequested() =
      DiscussionCanalsRequested;
}

@freezed
sealed class DiscussionCanalsExitAppEvent
    with _$DiscussionCanalsExitAppEvent
    implements AppTransitionEvent {
  const factory DiscussionCanalsExitAppEvent.leaveRequested() =
      DiscussionCanalsLeaveRequested;
}

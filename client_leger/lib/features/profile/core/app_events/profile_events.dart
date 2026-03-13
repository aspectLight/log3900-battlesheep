import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';

part 'profile_events.freezed.dart';

@freezed
sealed class ProfileEntryAppEvent
    with _$ProfileEntryAppEvent
    implements AppTransitionEvent {
  const factory ProfileEntryAppEvent.requested() = ProfileRequested;
}

@freezed
class ProfileCompletedAppEvent
    with _$ProfileCompletedAppEvent
    implements AppTransitionEvent {
  const factory ProfileCompletedAppEvent() = _ProfileCompletedAppEvent;
}

@freezed
sealed class ProfileExitAppEvent
    with _$ProfileExitAppEvent
    implements AppTransitionEvent {
  const factory ProfileExitAppEvent.leaveRequested() = ProfileLeaveRequested;
}


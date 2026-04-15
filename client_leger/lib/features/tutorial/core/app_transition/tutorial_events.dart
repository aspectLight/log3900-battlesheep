import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';

part 'tutorial_events.freezed.dart';

@freezed
sealed class TutorialEntryAppEvent
    with _$TutorialEntryAppEvent
    implements AppTransitionEvent {
  const factory TutorialEntryAppEvent.requested() = TutorialRequested;
}

@freezed
sealed class TutorialExitAppEvent
    with _$TutorialExitAppEvent
    implements AppTransitionEvent {
  const factory TutorialExitAppEvent.leaveRequested() = TutorialLeaveRequested;
}

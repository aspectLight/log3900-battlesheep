import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';

part 'friends_events.freezed.dart';

@freezed
sealed class FriendsEntryAppEvent
    with _$FriendsEntryAppEvent
    implements AppTransitionEvent {
  const factory FriendsEntryAppEvent.requested() = FriendsRequested;
}

@freezed
sealed class FriendsExitAppEvent
    with _$FriendsExitAppEvent
    implements AppTransitionEvent {
  const factory FriendsExitAppEvent.leaveRequested() = FriendsLeaveRequested;
}

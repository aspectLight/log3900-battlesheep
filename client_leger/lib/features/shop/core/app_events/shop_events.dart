import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/app_transition/app_transition_bus.dart';

part 'shop_events.freezed.dart';

@freezed
sealed class ShopEntryAppEvent
    with _$ShopEntryAppEvent
    implements AppTransitionEvent {
  const factory ShopEntryAppEvent.requested() = ShopRequestEntry;
}

@freezed
class ShopCompletedAppEvent
    with _$ShopCompletedAppEvent
    implements AppTransitionEvent {
  const factory ShopCompletedAppEvent() = _ShopCompletedAppEvent;
}

@freezed
sealed class ShopExitAppEvent
    with _$ShopExitAppEvent
    implements AppTransitionEvent {
  const factory ShopExitAppEvent.leaveRequested() = ShopLeaveRequested;
}

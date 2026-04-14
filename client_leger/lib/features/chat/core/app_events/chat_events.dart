import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';

part 'chat_events.freezed.dart';

@freezed
sealed class ChatEntryAppEvent
    with _$ChatEntryAppEvent
    implements AppTransitionEvent {
  const factory ChatEntryAppEvent.authCompleted({required String username}) =
      ChatEnterAfterAuth;
}

@freezed
class ChatCompletedAppEvent
    with _$ChatCompletedAppEvent
    implements AppTransitionEvent {
  const factory ChatCompletedAppEvent() = _ChatCompletedAppEvent;
}

@freezed
sealed class ChatExitAppEvent
    with _$ChatExitAppEvent
    implements AppTransitionEvent {
  const factory ChatExitAppEvent.closed() = ChatClosedEvent;
}

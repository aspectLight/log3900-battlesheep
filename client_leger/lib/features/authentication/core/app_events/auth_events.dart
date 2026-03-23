import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../domain/models/user.dart';

part 'auth_events.freezed.dart';

@freezed
sealed class AuthEntryAppEvent
    with _$AuthEntryAppEvent
    implements AppTransitionEvent {
  const factory AuthEntryAppEvent.signInSuccess(UserModel user) =
      SignInSuccessEvent;

  const factory AuthEntryAppEvent.sessionConnected(String socketId) =
      SessionConnectedEvent;
}

@freezed
class AuthCompletedAppEvent
    with _$AuthCompletedAppEvent
    implements AppTransitionEvent {
  const factory AuthCompletedAppEvent({required String username}) =
      _AuthCompletedAppEvent;
}

@freezed
sealed class AuthExitAppEvent with _$AuthExitAppEvent implements AppTransitionEvent {
  const factory AuthExitAppEvent.signOut() = UserSignedOutEvent;

  const factory AuthExitAppEvent.appLifecycleDetached() =
      AppLifecycleDetachedEvent;
}

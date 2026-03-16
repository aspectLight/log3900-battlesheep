import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState.initial() = SessionDisconnected;
  const factory SessionState.connected(String socketId) = SessionConnected;
}

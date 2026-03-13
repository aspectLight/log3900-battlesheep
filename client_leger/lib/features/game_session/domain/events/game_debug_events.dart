import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_debug_events.freezed.dart';

@freezed
class DebugModeEnabledEvent with _$DebugModeEnabledEvent {
  const factory DebugModeEnabledEvent() = _DebugModeEnabledEvent;
}

@freezed
class DebugModeDisabledEvent with _$DebugModeDisabledEvent {
  const factory DebugModeDisabledEvent() = _DebugModeDisabledEvent;
}

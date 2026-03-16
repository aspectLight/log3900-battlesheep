import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_locked_event.freezed.dart';

@freezed
class RoomLockedEvent with _$RoomLockedEvent {
  const factory RoomLockedEvent() = _RoomLockedEvent;
}

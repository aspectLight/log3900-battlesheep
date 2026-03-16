import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_unlocked_event.freezed.dart';

@freezed
class RoomUnlockedEvent with _$RoomUnlockedEvent {
  const factory RoomUnlockedEvent() = _RoomUnlockedEvent;
}

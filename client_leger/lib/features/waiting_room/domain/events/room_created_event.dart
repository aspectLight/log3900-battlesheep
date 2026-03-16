import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/waiting_room_model.dart';

part 'room_created_event.freezed.dart';

@freezed
class RoomCreatedEvent with _$RoomCreatedEvent {
  const factory RoomCreatedEvent({required WaitingRoomModel room}) =
      _RoomCreatedEvent;
}

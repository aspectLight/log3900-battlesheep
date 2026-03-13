import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/waiting_room_model.dart';

part 'room_updated_event.freezed.dart';

@freezed
class RoomUpdatedEvent with _$RoomUpdatedEvent {
  const factory RoomUpdatedEvent({required WaitingRoomModel room}) =
      _RoomUpdatedEvent;
}

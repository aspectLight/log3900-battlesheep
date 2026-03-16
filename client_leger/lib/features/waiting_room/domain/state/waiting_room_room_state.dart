import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/waiting_room_model.dart';

part 'waiting_room_room_state.freezed.dart';

@freezed
class WaitingRoomRoomState with _$WaitingRoomRoomState {
  const factory WaitingRoomRoomState({
    required WaitingRoomModel room,
    required String socketId,
  }) = _WaitingRoomRoomState;

  const WaitingRoomRoomState._();

  bool get isHost => socketId == room.hostId;
}

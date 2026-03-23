import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/reservation_model.dart';

part 'waiting_room_reservations_state.freezed.dart';

@freezed
class WaitingRoomReservationsState with _$WaitingRoomReservationsState {
  const factory WaitingRoomReservationsState({
    required String roomId,
    @Default([]) List<ReservationModel> reservations,
  }) = _WaitingRoomReservationsState;
}

import '../../domain/events/reservations_updated_event.dart';
import '../../domain/state/waiting_room_reservations_state.dart';

class WaitingRoomReservationsStateReducer {
  WaitingRoomReservationsState reduce(
    WaitingRoomReservationsState previous,
    Object event,
  ) {
    if (event is ReservationsUpdatedEvent) {
      return WaitingRoomReservationsState(
        roomId: previous.roomId,
        reservations: event.reservations,
      );
    }
    return previous;
  }
}

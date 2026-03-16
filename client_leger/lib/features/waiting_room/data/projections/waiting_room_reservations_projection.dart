import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../domain/events/reservations_updated_event.dart';
import '../../domain/models/reservation_model.dart';
import '../repositories/waiting_room_reservations_repository.dart';
import '../services/waiting_room_socket.dart';

class WaitingRoomReservationsProjection implements EventProjection {
  WaitingRoomReservationsProjection({
    required WaitingRoomSocket socket,
    required WaitingRoomReservationsRepository repository,
  }) : _socket = socket,
       _repository = repository;

  final WaitingRoomSocket _socket;
  final WaitingRoomReservationsRepository _repository;

  @override
  List<StreamSubscription<dynamic>> subscribe() {
    return [
      _socket.updateCharacterReservedStream.listen(_onReservationsUpdated),
    ];
  }

  void _onReservationsUpdated(List<ReservationModel> reservations) {
    _repository.applyReservationsUpdated(
      ReservationsUpdatedEvent(reservations: reservations),
    );
  }
}

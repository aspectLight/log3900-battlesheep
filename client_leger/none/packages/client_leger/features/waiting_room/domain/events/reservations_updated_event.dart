import 'package:freezed_annotation/freezed_annotation.dart';

import '../models/reservation_model.dart';

part 'reservations_updated_event.freezed.dart';

@freezed
class ReservationsUpdatedEvent with _$ReservationsUpdatedEvent {
  const factory ReservationsUpdatedEvent({
    required List<ReservationModel> reservations,
  }) = _ReservationsUpdatedEvent;
}

import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/exceptions/waiting_room_failure.dart';
import '../../domain/commands/get_reserved_characters_command.dart';
import '../../domain/commands/reserve_character_command.dart';
import '../../domain/events/reservations_updated_event.dart';
import '../../domain/state/waiting_room_reservations_state.dart';
import '../reducers/waiting_room_reservations_state_reducer.dart';
import '../services/waiting_room_socket.dart';

class WaitingRoomReservationsRepository {
  WaitingRoomReservationsRepository({
    required String roomId,
    required WaitingRoomSocket socket,
    required WaitingRoomReservationsStateReducer reducer,
  })  : _socket = socket,
        _reducer = reducer,
        state = signal(WaitingRoomReservationsState(roomId: roomId));

  final WaitingRoomSocket _socket;
  final WaitingRoomReservationsStateReducer _reducer;

  final Signal<WaitingRoomReservationsState> state;

  void applyReservationsUpdated(ReservationsUpdatedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void requestReservedCharacters() {
    _socket.getReservedCharacters(
      GetReservedCharactersCommand(roomId: state.value.roomId),
    );
  }

  Future<Either<WaitingRoomFailure, void>> reserveCharacter(
    ReserveCharacterCommand command,
  ) =>
      _socket.reserveCharacter(command);
}


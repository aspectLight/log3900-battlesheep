import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../core/event_bus/waiting_room_event_bus.dart';
import '../../domain/events/player_created_event.dart';
import '../../domain/events/player_left_event.dart';
import '../../domain/events/room_created_event.dart';
import '../../domain/events/room_locked_event.dart';
import '../../domain/events/room_unlocked_event.dart';
import '../../domain/models/waiting_room_model.dart';
import '../../domain/models/waiting_room_player_model.dart';
import '../repositories/waiting_room_reservations_repository.dart';
import '../repositories/waiting_room_room_repository.dart';
import '../services/waiting_room_socket.dart';

class WaitingRoomRoomProjection implements EventProjection {
  WaitingRoomRoomProjection({
    required WaitingRoomSocket socket,
    required WaitingRoomRoomRepository repository,
    required WaitingRoomReservationsRepository reservationsRepository,
    required WaitingRoomEventBus eventBus,
  }) : _socket = socket,
       _repository = repository,
       _reservationsRepository = reservationsRepository,
       _eventBus = eventBus;

  final WaitingRoomSocket _socket;
  final WaitingRoomRoomRepository _repository;
  final WaitingRoomReservationsRepository _reservationsRepository;
  final WaitingRoomEventBus _eventBus;

  /// State updates (room locked, players, etc.) go to repository; events that
  /// imply leaving the feature or navigation (room canceled, player kicked) go
  /// to the feature event bus so a side effect can fire AppTransitionEventBus.
  @override
  List<StreamSubscription<dynamic>> subscribe() {
    return [
      _socket.waitingRoomCreatedStream.listen(_onRoomCreated),
      _socket.roomCanceledStream.listen(
        (_) => _eventBus.fire(const WaitingRoomCanceledEvent()),
      ),
      _socket.roomLockedStream.listen(
        (_) => _repository.applyRoomLocked(const RoomLockedEvent()),
      ),
      _socket.roomUnlockedStream.listen(
        (_) => _repository.applyRoomUnlocked(const RoomUnlockedEvent()),
      ),
      _socket.playerLeftStream.listen(_onPlayerLeft),
      _socket.playerCreatedStream.listen(_onPlayerCreated),
      _socket.playerKickedStream.listen(
        (_) => _eventBus.fire(const WaitingRoomPlayerKickedEvent()),
      ),
      _socket.waitingRoomErrorStream.listen(
        (failure) => _eventBus.fire(
          WaitingRoomFailureNotificationRequestedEvent(failure),
        ),
      ),
    ];
  }

  void _onRoomCreated(WaitingRoomModel room) {
    _repository.applyRoomCreated(RoomCreatedEvent(room: room));
  }

  void _onPlayerLeft(String playerId) {
    _repository.applyPlayerLeft(PlayerLeftEvent(playerId: playerId));
    _reservationsRepository.requestReservedCharacters();
  }

  void _onPlayerCreated(List<WaitingRoomPlayerModel> players) {
    _repository.applyPlayerCreated(PlayerCreatedEvent(players: players));
  }
}

import 'package:signals_flutter/signals_flutter.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/exceptions/waiting_room_failure.dart';
import '../../domain/commands/add_virtual_player_command.dart';
import '../../domain/commands/create_waiting_room_command.dart';
import '../../domain/commands/kick_player_command.dart';
import '../../domain/commands/leave_waiting_room_command.dart';
import '../../domain/commands/toggle_lock_waiting_room_command.dart';
import '../../domain/events/player_created_event.dart';
import '../../domain/events/player_joined_event.dart';
import '../../domain/events/player_left_event.dart';
import '../../domain/events/room_created_event.dart';
import '../../domain/events/room_locked_event.dart';
import '../../domain/events/room_unlocked_event.dart';
import '../../domain/events/room_updated_event.dart';
import '../../domain/models/waiting_room_model.dart';
import '../../domain/state/waiting_room_room_state.dart';
import '../reducers/waiting_room_room_state_reducer.dart';
import '../services/waiting_room_socket.dart';

class WaitingRoomRoomRepository {
  WaitingRoomRoomRepository({
    required WaitingRoomModel initialRoom,
    required String socketId,
    required WaitingRoomSocket socket,
    required WaitingRoomRoomStateReducer reducer,
  }) : _socket = socket,
       _reducer = reducer,
       state = signal(
         WaitingRoomRoomState(room: initialRoom, socketId: socketId),
       );

  final WaitingRoomSocket _socket;
  final WaitingRoomRoomStateReducer _reducer;

  final Signal<WaitingRoomRoomState> state;

  bool get isHost => state.value.isHost;

  void applyRoomCreated(RoomCreatedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyRoomUpdated(RoomUpdatedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyPlayerJoined(PlayerJoinedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyPlayerLeft(PlayerLeftEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyPlayerCreated(PlayerCreatedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyRoomLocked(RoomLockedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyRoomUnlocked(RoomUnlockedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void createRoom(CreateWaitingRoomCommand command) {
    _socket.createWaitingRoom(command);
  }

  Future<Either<WaitingRoomFailure, void>> leaveRoom(
    LeaveWaitingRoomCommand command,
  ) => _socket.leaveWaitingRoom(command);

  void toggleLock(ToggleLockWaitingRoomCommand command) {
    _socket.toggleLockWaitingRoom(command);
  }

  void kickPlayer(KickPlayerCommand command) {
    _socket.kickPlayer(command);
  }

  void addVirtualPlayer(AddVirtualPlayerCommand command) {
    _socket.createPlayer(command);
  }

  Future<Either<WaitingRoomFailure, void>> startGame() {
    final roomId = state.value.room.roomId;
    return _socket.startGame(roomId);
  }
}

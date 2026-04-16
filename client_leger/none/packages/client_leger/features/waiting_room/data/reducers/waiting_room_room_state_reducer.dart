import '../../domain/events/player_created_event.dart';
import '../../domain/events/player_joined_event.dart';
import '../../domain/events/player_left_event.dart';
import '../../domain/events/room_created_event.dart';
import '../../domain/events/room_locked_event.dart';
import '../../domain/events/room_unlocked_event.dart';
import '../../domain/events/room_updated_event.dart';
import '../../domain/models/waiting_room_model.dart';
import '../../domain/state/waiting_room_room_state.dart';

class WaitingRoomRoomStateReducer {
  WaitingRoomRoomState reduce(WaitingRoomRoomState previous, Object event) {
    if (event is RoomCreatedEvent) {
      return _reduceRoomCreated(previous, event);
    }
    if (event is RoomUpdatedEvent) {
      return _reduceRoomUpdated(previous, event);
    }
    if (event is PlayerJoinedEvent) {
      return _reducePlayerJoined(previous, event);
    }
    if (event is PlayerLeftEvent) {
      return _reducePlayerLeft(previous, event);
    }
    if (event is PlayerCreatedEvent) {
      return _reducePlayerCreated(previous, event);
    }
    if (event is RoomLockedEvent) {
      return _reduceRoomLocked(previous);
    }
    if (event is RoomUnlockedEvent) {
      return _reduceRoomUnlocked(previous);
    }
    return previous;
  }

  WaitingRoomRoomState _reduceRoomCreated(
    WaitingRoomRoomState previous,
    RoomCreatedEvent event,
  ) {
    return WaitingRoomRoomState(room: event.room, socketId: previous.socketId);
  }

  WaitingRoomRoomState _reduceRoomUpdated(
    WaitingRoomRoomState previous,
    RoomUpdatedEvent event,
  ) {
    return WaitingRoomRoomState(room: event.room, socketId: previous.socketId);
  }

  WaitingRoomRoomState _reducePlayerJoined(
    WaitingRoomRoomState previous,
    PlayerJoinedEvent event,
  ) {
    final updatedPlayers = [...previous.room.players, event.player];
    final updatedRoom = WaitingRoomModel(
      roomId: previous.room.roomId,
      hostId: previous.room.hostId,
      players: updatedPlayers,
      isLocked: previous.room.isLocked,
      dropInDropOut: previous.room.dropInDropOut,
      entryFee: previous.room.entryFee,
    );
    return WaitingRoomRoomState(room: updatedRoom, socketId: previous.socketId);
  }

  WaitingRoomRoomState _reducePlayerLeft(
    WaitingRoomRoomState previous,
    PlayerLeftEvent event,
  ) {
    final updatedPlayers = previous.room.players
        .where((p) => p.id != event.playerId)
        .toList();
    final updatedRoom = WaitingRoomModel(
      roomId: previous.room.roomId,
      hostId: previous.room.hostId,
      players: updatedPlayers,
      isLocked: previous.room.isLocked,
      dropInDropOut: previous.room.dropInDropOut,
      entryFee: previous.room.entryFee,
    );
    return WaitingRoomRoomState(room: updatedRoom, socketId: previous.socketId);
  }

  WaitingRoomRoomState _reducePlayerCreated(
    WaitingRoomRoomState previous,
    PlayerCreatedEvent event,
  ) {
    final updatedRoom = WaitingRoomModel(
      roomId: previous.room.roomId,
      hostId: previous.room.hostId,
      players: event.players,
      isLocked: previous.room.isLocked,
      dropInDropOut: previous.room.dropInDropOut,
      entryFee: previous.room.entryFee,
    );
    return WaitingRoomRoomState(room: updatedRoom, socketId: previous.socketId);
  }

  WaitingRoomRoomState _reduceRoomLocked(WaitingRoomRoomState previous) {
    final updatedRoom = WaitingRoomModel(
      roomId: previous.room.roomId,
      hostId: previous.room.hostId,
      players: previous.room.players,
      isLocked: true,
      dropInDropOut: previous.room.dropInDropOut,
      entryFee: previous.room.entryFee,
    );
    return WaitingRoomRoomState(room: updatedRoom, socketId: previous.socketId);
  }

  WaitingRoomRoomState _reduceRoomUnlocked(WaitingRoomRoomState previous) {
    final updatedRoom = WaitingRoomModel(
      roomId: previous.room.roomId,
      hostId: previous.room.hostId,
      players: previous.room.players,
      dropInDropOut: previous.room.dropInDropOut,
      entryFee: previous.room.entryFee,
    );
    return WaitingRoomRoomState(room: updatedRoom, socketId: previous.socketId);
  }
}

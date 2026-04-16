sealed class WaitingRoomFailure implements Exception {
  final String devMessage;

  const WaitingRoomFailure(this.devMessage);

  @override
  String toString() => devMessage;
}

class RoomNotFoundWaitingRoomFailure extends WaitingRoomFailure {
  const RoomNotFoundWaitingRoomFailure() : super('Room not found');
}

class RoomLockedWaitingRoomFailure extends WaitingRoomFailure {
  const RoomLockedWaitingRoomFailure() : super('Room locked');
}

class CharacterAlreadyReservedWaitingRoomFailure extends WaitingRoomFailure {
  const CharacterAlreadyReservedWaitingRoomFailure()
    : super('Character already reserved');
}

class VirtualPlayerNameUnavailableWaitingRoomFailure
    extends WaitingRoomFailure {
  const VirtualPlayerNameUnavailableWaitingRoomFailure()
    : super('No available virtual player name');
}

class PlayerKickedWaitingRoomFailure extends WaitingRoomFailure {
  const PlayerKickedWaitingRoomFailure() : super('Player kicked');
}

class MaxPlayerLimitReachedWaitingRoomFailure extends WaitingRoomFailure {
  const MaxPlayerLimitReachedWaitingRoomFailure()
    : super('Max player limit reached');
}

class PlayerAlreadyInRoomWaitingRoomFailure extends WaitingRoomFailure {
  const PlayerAlreadyInRoomWaitingRoomFailure()
    : super('Player already in room');
}

class StartGameFailedWaitingRoomFailure extends WaitingRoomFailure {
  const StartGameFailedWaitingRoomFailure() : super('Start game failed');
}

class UnknownWaitingRoomFailure extends WaitingRoomFailure {
  const UnknownWaitingRoomFailure(super.devMessage);
}

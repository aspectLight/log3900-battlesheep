sealed class JoinGameSessionFailure implements Exception {
  final String devMessage;

  const JoinGameSessionFailure(this.devMessage);

  @override
  String toString() => devMessage;
}

class RoomNotFoundJoinGameSessionFailure extends JoinGameSessionFailure {
  const RoomNotFoundJoinGameSessionFailure() : super('Room not found');
}

class RoomLockedJoinGameSessionFailure extends JoinGameSessionFailure {
  const RoomLockedJoinGameSessionFailure() : super('Room locked');
}

class MaxPlayerLimitReachedJoinGameSessionFailure extends JoinGameSessionFailure {
  const MaxPlayerLimitReachedJoinGameSessionFailure()
      : super('Max player limit reached');
}

class UnknownJoinGameSessionFailure extends JoinGameSessionFailure {
  const UnknownJoinGameSessionFailure(super.devMessage);
}

sealed class SelectGameSessionFailure implements Exception {
  final String devMessage;

  const SelectGameSessionFailure(this.devMessage);

  @override
  String toString() => devMessage;
}

class NetworkSelectGameSessionFailure extends SelectGameSessionFailure {
  const NetworkSelectGameSessionFailure()
    : super('Network error while loading games');
}

class ServerSelectGameSessionFailure extends SelectGameSessionFailure {
  const ServerSelectGameSessionFailure()
    : super('Server error while loading games');
}

class GameNotFoundSelectGameSessionFailure extends SelectGameSessionFailure {
  const GameNotFoundSelectGameSessionFailure()
    : super('Game not found or was deleted');
}

class GameNotVisibleSelectGameSessionFailure extends SelectGameSessionFailure {
  const GameNotVisibleSelectGameSessionFailure()
    : super('Game is not visible');
}

class UnknownSelectGameSessionFailure extends SelectGameSessionFailure {
  const UnknownSelectGameSessionFailure(super.devMessage);
}

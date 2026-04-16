sealed class GameHistoryFailure implements Exception {
  final String devMessage;

  const GameHistoryFailure(this.devMessage);

  @override
  String toString() => devMessage;
}

class LoadFailedGameHistoryFailure extends GameHistoryFailure {
  const LoadFailedGameHistoryFailure() : super('Failed to load game history');
}

class UnknownGameHistoryFailure extends GameHistoryFailure {
  const UnknownGameHistoryFailure(super.devMessage);
}

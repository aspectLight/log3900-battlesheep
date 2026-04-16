import '../enums/game_session_error.dart';

sealed class GameException implements Exception {
  final String devMessage;

  const GameException(this.devMessage);

  GameSessionError get errorType;

  @override
  String toString() => devMessage;
}

class GameNotFoundException extends GameException {
  const GameNotFoundException([super.devMessage = 'Game not found']);

  @override
  GameSessionError get errorType => GameSessionError.gameNotFound;
}

class NetworkException extends GameException {
  const NetworkException([super.devMessage = 'Network connection problem']);

  @override
  GameSessionError get errorType => GameSessionError.network;
}

class ServerException extends GameException {
  final int? statusCode;

  const ServerException({this.statusCode, String? devMessage})
    : super(devMessage ?? 'Server error');

  @override
  GameSessionError get errorType => GameSessionError.server;
}

class UnknownGameException extends GameException {
  const UnknownGameException(super.devMessage);

  @override
  GameSessionError get errorType => GameSessionError.unknown;
}

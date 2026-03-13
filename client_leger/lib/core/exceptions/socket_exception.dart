abstract class SocketException implements Exception {
  const SocketException();

  String get devMessage;

  @override
  String toString() => devMessage;
}

class NotConnectedException extends SocketException {
  const NotConnectedException();

  @override
  String get devMessage => 'Not connected';
}

class ConnectionFailedException extends SocketException {
  @override
  final String devMessage;

  const ConnectionFailedException([this.devMessage = 'Connection failed']);
}

class SocketTimeoutException extends SocketException {
  const SocketTimeoutException();

  @override
  String get devMessage => 'Socket timeout';
}

class UnknownSocketException extends SocketException {
  @override
  final String devMessage;

  const UnknownSocketException(this.devMessage);
}

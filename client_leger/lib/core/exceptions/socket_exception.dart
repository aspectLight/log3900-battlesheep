sealed class SocketException implements Exception {
  const SocketException();
}

class NotConnectedException extends SocketException {
  const NotConnectedException();
}

class ConnectionFailedException extends SocketException {
  final String? message;
  const ConnectionFailedException([this.message]);
}

class SocketTimeoutException extends SocketException {
  const SocketTimeoutException();
}

class UnknownSocketException extends SocketException {
  final String message;
  const UnknownSocketException(this.message);
}

sealed class AuthException implements Exception {
  final String devMessage;

  const AuthException(this.devMessage);

  @override
  String toString() => devMessage;
}

class InvalidCredentialsException extends AuthException {
  const InvalidCredentialsException() : super('Invalid credentials');
}

class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException() : super('Email already in use');
}

class UserNotFoundException extends AuthException {
  const UserNotFoundException() : super('User not found');
}

class NetworkException extends AuthException {
  const NetworkException() : super('Network connection problem');
}

class ServerException extends AuthException {
  final int? statusCode;

  const ServerException({this.statusCode, String? devMessage})
    : super(devMessage ?? 'Server error');
}

class UnknownAuthException extends AuthException {
  const UnknownAuthException(super.devMessage);
}

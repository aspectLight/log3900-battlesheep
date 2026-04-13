sealed class ProfileFailure implements Exception {
  const ProfileFailure(this.devMessage);

  final String devMessage;

  @override
  String toString() => devMessage;
}

class NetworkProfileFailure extends ProfileFailure {
  const NetworkProfileFailure() : super('Network connection problem');
}

class UnauthorizedProfileFailure extends ProfileFailure {
  const UnauthorizedProfileFailure() : super('Unauthorized');
}

class BadRequestProfileFailure extends ProfileFailure {
  const BadRequestProfileFailure() : super('Bad request');
}

class ForbiddenProfileFailure extends ProfileFailure {
  const ForbiddenProfileFailure() : super('Forbidden');
}

class NotFoundProfileFailure extends ProfileFailure {
  const NotFoundProfileFailure() : super('Not found');
}

class UsernameAlreadyInUseProfileFailure extends ProfileFailure {
  const UsernameAlreadyInUseProfileFailure() : super('Username already in use');
}

class EmailAlreadyInUseProfileFailure extends ProfileFailure {
  const EmailAlreadyInUseProfileFailure() : super('Email already in use');
}

class ServerProfileFailure extends ProfileFailure {
  final int? statusCode;

  const ServerProfileFailure({this.statusCode, String devMessage = 'Server error'})
      : super(devMessage);
}

class NoChangesProfileFailure extends ProfileFailure {
  const NoChangesProfileFailure() : super('No profile changes');
}

class UnknownProfileFailure extends ProfileFailure {
  const UnknownProfileFailure([super.devMessage = 'Unknown profile error']);
}

sealed class ProfileFailure implements Exception {
  final String devMessage;

  const ProfileFailure(this.devMessage);

  @override
  String toString() => devMessage;
}

class NetworkProfileFailure extends ProfileFailure {
  const NetworkProfileFailure() : super('Network error while loading profile');
}

class UnauthorizedProfileFailure extends ProfileFailure {
  const UnauthorizedProfileFailure()
      : super('Unauthorized when accessing profile');
}

class ValidationProfileFailure extends ProfileFailure {
  const ValidationProfileFailure() : super('Profile validation failed');
}

class UnknownProfileFailure extends ProfileFailure {
  const UnknownProfileFailure() : super('Unknown profile error');
}


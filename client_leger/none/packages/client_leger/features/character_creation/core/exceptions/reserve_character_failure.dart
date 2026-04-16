sealed class ReserveCharacterFailure implements Exception {
  final String devMessage;

  const ReserveCharacterFailure(this.devMessage);

  @override
  String toString() => devMessage;
}

class CharacterAlreadyReservedReserveCharacterFailure
    extends ReserveCharacterFailure {
  const CharacterAlreadyReservedReserveCharacterFailure()
    : super('Character already reserved');
}

class RoomLockedReserveCharacterFailure extends ReserveCharacterFailure {
  const RoomLockedReserveCharacterFailure() : super('Room locked');
}

class UnknownReserveCharacterFailure extends ReserveCharacterFailure {
  const UnknownReserveCharacterFailure(super.devMessage);
}

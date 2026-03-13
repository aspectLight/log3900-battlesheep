import '../exceptions/reserve_character_failure.dart';

ReserveCharacterFailure reserveCharacterFailureFromServerMessage(
  String? message,
) {
  if (message == null || message.isEmpty) {
    return const UnknownReserveCharacterFailure('Unknown error');
  }
  final normalized = message.toLowerCase();
  if (normalized.contains('already reserved') ||
      normalized.contains('déjà réservé') ||
      normalized.contains('deja reserve')) {
    return const CharacterAlreadyReservedReserveCharacterFailure();
  }
  if (normalized.contains('locked') ||
      normalized.contains('verrouillée') ||
      normalized.contains('verrouillee')) {
    return const RoomLockedReserveCharacterFailure();
  }
  return UnknownReserveCharacterFailure(message);
}

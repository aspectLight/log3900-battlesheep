import '../localisation/character_creation_localizations.dart';
import '../exceptions/reserve_character_failure.dart';

extension ReserveCharacterFailureExt on ReserveCharacterFailure {
  String localize(CharacterCreationLocalizations l10n) =>
      l10n.reserveCharacterFailed;
}

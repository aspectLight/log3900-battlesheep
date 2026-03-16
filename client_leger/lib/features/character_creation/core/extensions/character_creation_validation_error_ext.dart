import '../localisation/character_creation_localizations.dart';
import '../enums/character_creation_validation_error.dart';

extension CharacterCreationValidationErrorExt on CharacterCreationValidationError {
  String localize(CharacterCreationLocalizations l10n) {
    return switch (this) {
      CharacterCreationValidationError.characterRequired =>
        l10n.characterCreationValidationMessage,
      CharacterCreationValidationError.nameRequired =>
        l10n.characterCreationValidationMessage,
      CharacterCreationValidationError.bonusRequired =>
        l10n.characterCreationValidationMessage,
      CharacterCreationValidationError.diceRequired =>
        l10n.characterCreationValidationMessage,
    };
  }
}

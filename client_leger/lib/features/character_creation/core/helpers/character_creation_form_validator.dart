import '../constants/character_creation_constants.dart';
import '../enums/character_creation_validation_error.dart';
import '../../domain/models/character_creation_form.dart';

class CharacterCreationFormValidator {
  CharacterCreationFormValidator._();

  static const int d4 = CharacterCreationConstants.d4Value;
  static const int d6 = CharacterCreationConstants.d6Value;

  static bool isValidDiceValue(int value) =>
      value == d4 || value == d6;

  static List<CharacterCreationValidationError> validateAll(
    CharacterCreationForm form,
  ) {
    final errors = <CharacterCreationValidationError>[];
    if (!form.selectedCharacterId.fold(() => false, (id) => id.isNotEmpty)) {
      errors.add(CharacterCreationValidationError.characterRequired);
    }
    if (form.name.trim().isEmpty) {
      errors.add(CharacterCreationValidationError.nameRequired);
    }
    if (!hasValidStatBonusPairing(form)) {
      errors.add(CharacterCreationValidationError.bonusRequired);
    }
    if (!isValidDiceValue(form.attackDice) ||
        !isValidDiceValue(form.defenseDice) ||
        form.attackDice == form.defenseDice) {
      errors.add(CharacterCreationValidationError.diceRequired);
    }
    return errors;
  }

  /// Exactly one of health or speed has the +2 bonus (6); the other is base (4).
  static bool hasValidStatBonusPairing(CharacterCreationForm form) =>
      _hasValidBonus(form);

  static bool isHealthBonusChoiceActive(CharacterCreationForm form) =>
      hasValidStatBonusPairing(form) &&
      form.health == CharacterCreationConstants.statWithBonusValue;

  static bool isSpeedBonusChoiceActive(CharacterCreationForm form) =>
      hasValidStatBonusPairing(form) &&
      form.speed == CharacterCreationConstants.statWithBonusValue;

  static bool hasValidDicePairing(CharacterCreationForm form) =>
      isValidDiceValue(form.attackDice) &&
      isValidDiceValue(form.defenseDice) &&
      form.attackDice != form.defenseDice;

  static bool _hasValidBonus(CharacterCreationForm form) {
    final hasHealthBonus =
        form.health == CharacterCreationConstants.statWithBonusValue;
    final hasSpeedBonus =
        form.speed == CharacterCreationConstants.statWithBonusValue;
    if (hasHealthBonus == hasSpeedBonus) return false;
    return true;
  }
}

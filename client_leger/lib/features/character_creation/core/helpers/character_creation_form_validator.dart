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
    if (!_hasValidBonus(form)) {
      errors.add(CharacterCreationValidationError.bonusRequired);
    }
    if (!isValidDiceValue(form.attackDice) ||
        !isValidDiceValue(form.defenseDice) ||
        form.attackDice == form.defenseDice) {
      errors.add(CharacterCreationValidationError.diceRequired);
    }
    return errors;
  }

  static bool _hasValidBonus(CharacterCreationForm form) {
    final hasHealthBonus =
        form.health == CharacterCreationConstants.statWithBonusValue;
    final hasSpeedBonus =
        form.speed == CharacterCreationConstants.statWithBonusValue;
    if (hasHealthBonus == hasSpeedBonus) return false;
    return true;
  }
}

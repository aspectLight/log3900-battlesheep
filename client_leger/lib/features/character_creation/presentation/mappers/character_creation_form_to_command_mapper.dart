import 'package:fpdart/fpdart.dart';

import '../../../../core/enums/avatar.dart';
import '../../core/constants/character_creation_constants.dart';
import '../../core/enums/character_creation_bonus_choice.dart';
import '../../core/enums/character_creation_dice_stat_choice.dart';
import '../../domain/commands/create_character_commands.dart';
import '../../domain/models/character_creation_form.dart';

CreateCharacterCommand toCommand(CharacterCreationForm form, String roomCode) {
  return CreateCharacterCommand(roomId: roomCode, player: _toPlayerData(form));
}

CreateCharacterPlayerData _toPlayerData(CharacterCreationForm form) {
  final characterId = form.selectedCharacterId.getOrElse(
    () => Avatar.dmitry.id,
  );
  final bonus = _bonusChoice(form);
  final d6 = _d6Choice(form);
  final d4 = _d4Choice(form);
  return CreateCharacterPlayerData(
    name: form.name.trim(),
    characterId: characterId,
    bonusChoice: bonus,
    d6Choice: d6,
    d4Choice: d4,
    health: form.health,
    speed: form.speed,
    attackDice: form.attackDice,
    defenseDice: form.defenseDice,
  );
}

CharacterCreationBonusChoice _bonusChoice(CharacterCreationForm form) {
  return form.health == CharacterCreationConstants.statWithBonusValue
      ? CharacterCreationBonusChoice.health
      : CharacterCreationBonusChoice.speed;
}

CharacterCreationDiceStatChoice _d6Choice(CharacterCreationForm form) {
  return form.defenseDice == CharacterCreationConstants.d6Value
      ? CharacterCreationDiceStatChoice.defense
      : CharacterCreationDiceStatChoice.attack;
}

CharacterCreationDiceStatChoice _d4Choice(CharacterCreationForm form) {
  return form.defenseDice == CharacterCreationConstants.d4Value
      ? CharacterCreationDiceStatChoice.defense
      : CharacterCreationDiceStatChoice.attack;
}

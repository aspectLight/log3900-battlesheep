enum CharacterCreationDiceStatChoice {
  attack,
  defense,
}

extension CharacterCreationDiceStatChoiceExt on CharacterCreationDiceStatChoice {
  String get toServerValue => switch (this) {
        CharacterCreationDiceStatChoice.attack => 'attack',
        CharacterCreationDiceStatChoice.defense => 'defense',
      };
}

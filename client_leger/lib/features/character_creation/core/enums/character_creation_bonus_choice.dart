enum CharacterCreationBonusChoice { health, speed }

extension CharacterCreationBonusChoiceExt on CharacterCreationBonusChoice {
  String get toServerValue => switch (this) {
    CharacterCreationBonusChoice.health => 'health',
    CharacterCreationBonusChoice.speed => 'speed',
  };
}

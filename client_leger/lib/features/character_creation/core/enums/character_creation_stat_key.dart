enum CharacterCreationStatKey { health, speed, attack, defense }

extension CharacterCreationStatKeyExt on CharacterCreationStatKey {
  String get toServerValue => switch (this) {
    CharacterCreationStatKey.health => 'health',
    CharacterCreationStatKey.speed => 'speed',
    CharacterCreationStatKey.attack => 'attack',
    CharacterCreationStatKey.defense => 'defense',
  };
}

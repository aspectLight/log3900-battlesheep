enum Character {
  viktor,
  petrov,
  dmitry,
  ladeve,
  irina,
  sokolov,
  georgie,
  misha,
  gorkina,
  sergei,
  ivanov,
  volkov;

  String get id => name;

  static Character fromId(String id) => Character.values.byName(id);

  static Character fromAvatarName(String name) {
    final lower = name.toLowerCase();
    for (final e in Character.values) {
      if (e.name.toLowerCase() == lower) return e;
    }
    return Character.dmitry;
  }
}

extension CharacterExt on Character {
  String get displayName => '${id[0].toUpperCase()}${id.substring(1)}';
}

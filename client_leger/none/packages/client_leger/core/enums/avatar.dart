enum Avatar {
  dmitry,
  georgie,
  gorkina,
  irina,
  ivanov,
  ladeve,
  misha,
  petrov,
  sergei,
  sokolov,
  viktor,
  volkov;

  String get id => name;

  static Avatar fromId(String id) => Avatar.values.byName(id);
}

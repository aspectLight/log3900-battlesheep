enum VirtualPlayerType {
  aggressive,
  defensive;

  String get id => name;

  static VirtualPlayerType fromId(String id) =>
      VirtualPlayerType.values.byName(id);
}

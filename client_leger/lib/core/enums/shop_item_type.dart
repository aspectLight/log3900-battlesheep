enum ShopItemType {
  avatar,
  banner,
  character;

  static ShopItemType fromWire(String value) {
    return ShopItemType.values.firstWhere(
      (e) => e.name == value,
      orElse: () =>
          throw ArgumentError('Unknown shop item type: $value'),
    );
  }
}

import '../enums/asset_extension.dart';
import '../enums/item_type.dart';

class ItemAssets {
  static const String path = 'assets/images/game_board_items';

  static const Map<ItemType, AssetExtension> _extensions = {
    ItemType.spawnPoint: AssetExtension.gif,
  };

  static String gameBoardItem(ItemType type) {
    final ext = _extensions[type] ?? AssetExtension.png;
    return '$path/${type.name}.${ext.value}';
  }
}

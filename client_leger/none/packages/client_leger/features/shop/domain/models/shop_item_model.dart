import '../../../../core/enums/shop_catalog_item_id.dart';
import '../../../../core/enums/shop_item_type.dart';

class ShopItemModel {
  final ShopCatalogItemId id;
  final String name;
  final ShopItemType type;
  final int price;

  const ShopItemModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
  });
}

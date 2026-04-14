import '../../../../core/enums/shop_catalog_item_id.dart';

class PurchaseItemCommand {
  final ShopCatalogItemId itemId;

  const PurchaseItemCommand({required this.itemId});
}

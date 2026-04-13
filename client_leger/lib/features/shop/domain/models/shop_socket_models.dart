import '../../../../core/enums/shop_catalog_item_id.dart';
import '../../core/exceptions/shop_purchase_exception.dart';
import 'shop_item_model.dart';

class ShopCatalogModel {
  final bool success;
  final List<ShopItemModel> catalogue;
  final List<ShopCatalogItemId> purchasedItems;
  final String? error;

  const ShopCatalogModel({
    required this.success,
    required this.catalogue,
    required this.purchasedItems,
    this.error,
  });
}

class ShopCurrencyModel {
  final bool success;
  final int? balance;
  final String? error;

  const ShopCurrencyModel({
    required this.success,
    this.balance,
    this.error,
  });
}

class ShopPurchaseModel {
  final bool success;
  final int? newBalance;
  final List<ShopCatalogItemId> purchasedItems;
  final ShopPurchaseException? failure;

  const ShopPurchaseModel({
    required this.success,
    this.newBalance,
    required this.purchasedItems,
    this.failure,
  });
}

import '../enums/shop_purchase_error.dart';
import '../localisation/shop_localizations.dart';

extension ShopPurchaseErrorExt on ShopPurchaseError {
  String localize(ShopLocalizations l10n) {
    return switch (this) {
      ShopPurchaseError.insufficientFunds =>
        l10n.shopPurchaseFailedInsufficientFunds,
      ShopPurchaseError.alreadyPurchased =>
        l10n.shopPurchaseFailedAlreadyPurchased,
      ShopPurchaseError.itemNotFound => l10n.shopPurchaseFailedItemNotFound,
      ShopPurchaseError.notAuthenticated =>
        l10n.shopPurchaseFailedNotAuthenticated,
      ShopPurchaseError.unknown => l10n.shopPurchaseFailedUnknown,
    };
  }
}

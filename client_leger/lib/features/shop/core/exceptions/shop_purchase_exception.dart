import '../enums/shop_purchase_error.dart';

sealed class ShopPurchaseException implements Exception {
  final String devMessage;

  const ShopPurchaseException(this.devMessage);

  ShopPurchaseError get errorType;

  @override
  String toString() => devMessage;
}

class InsufficientFundsShopPurchaseException extends ShopPurchaseException {
  const InsufficientFundsShopPurchaseException([
    super.devMessage = 'Insufficient balance',
  ]);

  @override
  ShopPurchaseError get errorType => ShopPurchaseError.insufficientFunds;
}

class AlreadyPurchasedShopPurchaseException extends ShopPurchaseException {
  const AlreadyPurchasedShopPurchaseException([
    super.devMessage = 'Item already purchased',
  ]);

  @override
  ShopPurchaseError get errorType => ShopPurchaseError.alreadyPurchased;
}

class ItemNotFoundShopPurchaseException extends ShopPurchaseException {
  const ItemNotFoundShopPurchaseException([
    super.devMessage = 'Item not found in shop',
  ]);

  @override
  ShopPurchaseError get errorType => ShopPurchaseError.itemNotFound;
}

class NotAuthenticatedShopPurchaseException extends ShopPurchaseException {
  const NotAuthenticatedShopPurchaseException([
    super.devMessage = 'Not authenticated',
  ]);

  @override
  ShopPurchaseError get errorType => ShopPurchaseError.notAuthenticated;
}

class UnknownShopPurchaseException extends ShopPurchaseException {
  const UnknownShopPurchaseException(super.devMessage);

  @override
  ShopPurchaseError get errorType => ShopPurchaseError.unknown;
}

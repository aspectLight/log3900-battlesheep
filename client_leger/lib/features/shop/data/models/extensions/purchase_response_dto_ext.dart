import '../../../../../core/enums/shop_catalog_item_id.dart';
import '../../../core/exceptions/shop_purchase_exception.dart';
import '../../../domain/models/shop_socket_models.dart';
import '../dto/purchase_response_dto.dart';

ShopPurchaseException _failureFromPurchaseResponse(PurchaseResponseDto dto) {
  final e = dto.error?.trim() ?? '';
  return switch (e) {
    'Solde insuffisant' => const InsufficientFundsShopPurchaseException(),
    'Article déjà acheté' => const AlreadyPurchasedShopPurchaseException(),
    'Article introuvable dans la boutique' =>
      const ItemNotFoundShopPurchaseException(),
    'Non authentifié' => const NotAuthenticatedShopPurchaseException(),
    _ => UnknownShopPurchaseException(
        e.isEmpty ? 'Unknown shop purchase error' : e,
      ),
  };
}

extension PurchaseResponseDtoExt on PurchaseResponseDto {
  ShopPurchaseModel toModel() {
    final ok = success && newBalance != null;
    return ShopPurchaseModel(
      success: success,
      newBalance: newBalance,
      purchasedItems: purchasedItems.map(ShopCatalogItemId.parse).toList(),
      failure: ok ? null : _failureFromPurchaseResponse(this),
    );
  }
}

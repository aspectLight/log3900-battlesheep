import '../../../../core/constants/ui_assets.dart';
import '../../../../core/enums/shop_catalog_item_id.dart';

class ShopAssetPaths {
  ShopAssetPaths._();

  static const String coinIcon = UiAssets.goldCoin;

  static const String _shopAvatars = 'assets/images/shop_avatars';

  static const String _avatars = 'assets/images/avatars';

  static String? imageAssetFor(ShopCatalogItemId id) {
    return switch (id) {
      ShopCatalogItemId.streetFighter => '$_shopAvatars/street-fighter.png',
      ShopCatalogItemId.tacticalOperator =>
        '$_shopAvatars/tactical-operator.png',
      ShopCatalogItemId.screamGhostface => '$_shopAvatars/scream-ghostface.png',
      ShopCatalogItemId.sergei => '$_avatars/sergeiAvatar.png',
      ShopCatalogItemId.sokolov => '$_avatars/sokolovAvatar.png',
      ShopCatalogItemId.viktor => '$_avatars/viktorAvatar.png',
      ShopCatalogItemId.volkov => '$_avatars/volkovAvatar.png',
      ShopCatalogItemId.bannerGold ||
      ShopCatalogItemId.bannerShadow ||
      ShopCatalogItemId.bannerFlame ||
      ShopCatalogItemId.bannerIce ||
      ShopCatalogItemId.bannerNeon => null,
    };
  }
}

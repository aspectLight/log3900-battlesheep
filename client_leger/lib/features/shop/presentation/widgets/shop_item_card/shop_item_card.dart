import 'package:flutter/material.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../../../core/enums/shop_catalog_item_id.dart';
import '../../../../../core/enums/shop_item_type.dart';
import '../../../core/constants/shop_asset_paths.dart';
import '../../../core/localisation/shop_localizations.dart';
import '../../../domain/models/shop_item_model.dart';
import '../shop_banner_card/shop_banner_card.dart';

class ShopItemCard extends StatelessWidget {
  const ShopItemCard({
    super.key,
    required this.item,
    required this.owned,
    required this.onBuy,
    this.equipped = false,
    this.onEquipToggle,
  });

  final ShopItemModel item;
  final bool owned;
  final bool equipped;
  final VoidCallback onBuy;
  final VoidCallback? onEquipToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = ShopLocalizations.of(context)!;
    final asset = ShopAssetPaths.imageAssetFor(item.id);

    return Container(
      width: 180,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: owned ? const Color(0xD9071607) : const Color(0xD9160707),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: equipped
              ? const Color(0xFF2E7D32)
              : owned
              ? const Color(0xFF2E7D32)
              : const Color(0xFF3A3A3A),
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.type == ShopItemType.banner)
            ShopBannerCard(bannerId: item.id)
          else if (asset != null)
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: ColoredBox(
                  color: Colors.black26,
                  child: Image.asset(asset, fit: BoxFit.contain),
                ),
              ),
            ),
          const SizedBox(height: 6),
          if (item.type == ShopItemType.banner)
            Text(
              getBannerName(item.id, l10n),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0F0F0),
                fontFamily: 'CustomFont',
                fontSize: 14,
              ),
            )
          else if (asset != null)
            Text(
              item.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFF0F0F0),
                fontFamily: 'CustomFont',
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 4),
          ShopCoinPrice(price: item.price),
          const SizedBox(height: 8),
          if (owned &&
              item.type == ShopItemType.banner &&
              onEquipToggle != null)
            ElevatedButton(
              onPressed: onEquipToggle,
              style: ElevatedButton.styleFrom(
                backgroundColor: equipped
                    ? const Color(0xFF2E7D32)
                    : Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                side: const BorderSide(color: Color(0xFF266629)),
                textStyle: const TextStyle(
                  fontFamily: 'CustomFont',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Text(equipped ? l10n.shopUnequip : l10n.shopEquip),
            )
          else if (owned)
            Text(
              l10n.shopOwned,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF4CAF50),
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            )
          else
            ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: context.interactionColors.primary,
                foregroundColor: Colors.white,
                side: BorderSide(color: context.interactionColors.outline),
                padding: const EdgeInsets.symmetric(vertical: 8),
                textStyle: const TextStyle(
                  fontFamily: 'CustomFont',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(l10n.shopBuy),
            ),
        ],
      ),
    );
  }
}

String getBannerName(ShopCatalogItemId name, ShopLocalizations l10n) {
  return switch (name) {
    ShopCatalogItemId.bannerGold => l10n.bannerGold,
    ShopCatalogItemId.bannerShadow => l10n.bannerShadow,
    ShopCatalogItemId.bannerFlame => l10n.bannerFlame,
    ShopCatalogItemId.bannerIce => l10n.bannerIce,
    ShopCatalogItemId.bannerNeon => l10n.bannerNeon,
    _ => name.wireValue,
  };
}

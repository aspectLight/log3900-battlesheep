import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/enums/shop_catalog_item_id.dart';
import '../../../core/constants/shop_asset_paths.dart';
import '../../../core/localisation/shop_localizations.dart';

BoxDecoration _bannerDecoration(ShopCatalogItemId bannerId) {
  return switch (bannerId) {
    ShopCatalogItemId.bannerGold => const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF8B6914), Color(0xFFD4AF37), Color(0xFF5C4A0E)],
      ),
    ),
    ShopCatalogItemId.bannerShadow => const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F0F1A)],
      ),
    ),
    ShopCatalogItemId.bannerFlame => const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        colors: [Color(0xFF4A0E0E), Color(0xFFFF5722), Color(0xFFFFC107)],
      ),
    ),
    ShopCatalogItemId.bannerIce => const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF4FC3F7), Color(0xFFE1F5FE), Color(0xFF0277BD)],
      ),
    ),
    ShopCatalogItemId.bannerNeon => const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF311B92), Color(0xFFE040FB), Color(0xFF00E5FF)],
      ),
    ),
    ShopCatalogItemId.streetFighter ||
    ShopCatalogItemId.tacticalOperator ||
    ShopCatalogItemId.screamGhostface ||
    ShopCatalogItemId.sergei ||
    ShopCatalogItemId.sokolov ||
    ShopCatalogItemId.viktor ||
    ShopCatalogItemId.volkov =>
      const BoxDecoration(color: Color(0xFF3A1212)),
  };
}

class ShopBannerCard extends StatelessWidget {
  const ShopBannerCard({
    super.key,
    required this.bannerId,
  });

  final ShopCatalogItemId bannerId;

  @override
  Widget build(BuildContext context) {
    final l10n = ShopLocalizations.of(context)!;
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: DecoratedBox(
          decoration: _bannerDecoration(bannerId),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final side = math
                          .min(
                            36,
                            math.min(
                              constraints.maxWidth,
                              constraints.maxHeight,
                            ),
                          )
                          .toDouble();
                      return Center(
                        child: Container(
                          width: side,
                          height: side,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white24,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.15),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.shopBannerPreviewPlayer,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _miniStat(l10n.shopBannerPreviewHp),
                      _miniStat(l10n.shopBannerPreviewSpeed),
                      _miniStat(l10n.shopBannerPreviewAttack),
                      _miniStat(l10n.shopBannerPreviewDefense),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _miniStat(String label) {
    return Text(
      label,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 8,
        height: 1.05,
        fontFamily: 'CustomFont',
      ),
    );
  }
}

class ShopCoinPrice extends StatelessWidget {
  const ShopCoinPrice({
    super.key,
    required this.price,
  });

  final int price;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$price',
          style: const TextStyle(
            color: Color(0xFFF0C040),
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'CustomFont',
          ),
        ),
        const SizedBox(width: 6),
        Image.asset(
          ShopAssetPaths.coinIcon,
          width: 20,
          height: 20,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.monetization_on,
            color: Color(0xFFF0C040),
            size: 20,
          ),
        ),
      ],
    );
  }
}

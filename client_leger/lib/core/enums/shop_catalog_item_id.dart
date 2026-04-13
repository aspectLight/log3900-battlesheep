enum ShopCatalogItemId {
  bannerGold('banner_gold'),
  bannerShadow('banner_shadow'),
  bannerFlame('banner_flame'),
  bannerIce('banner_ice'),
  bannerNeon('banner_neon'),
  streetFighter('streetFighter'),
  tacticalOperator('tacticalOperator'),
  screamGhostface('screamGhostface'),
  sergei('sergei'),
  sokolov('sokolov'),
  viktor('viktor'),
  volkov('volkov'),
  ;

  const ShopCatalogItemId(this.wireValue);
  final String wireValue;

  static ShopCatalogItemId parse(String raw) {
    return ShopCatalogItemId.values.firstWhere(
      (e) => e.wireValue == raw,
      orElse: () => throw ArgumentError.value(
        raw,
        'id',
        'Unknown shop catalog item id',
      ),
    );
  }
}

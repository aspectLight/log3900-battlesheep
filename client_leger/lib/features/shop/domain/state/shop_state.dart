import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/enums/shop_catalog_item_id.dart';
import '../models/shop_item_model.dart';

part 'shop_state.freezed.dart';

@freezed
sealed class ShopState with _$ShopState {
  const factory ShopState.loading() = ShopStateLoading;

  const factory ShopState.loaded({
    required List<ShopItemModel> catalogue,
    required List<ShopCatalogItemId> purchasedItems,
    required int balance,
  }) = ShopStateLoaded;
}

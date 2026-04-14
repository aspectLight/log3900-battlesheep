import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/enums/shop_catalog_item_id.dart';
import '../../../../../core/enums/shop_item_type.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../domain/models/shop_item_model.dart';
import '../../../domain/state/shop_state.dart';

class ShopViewModel {
  ShopViewModel({required ShopRepository repository})
    : _repository = repository,
      state = computed(() => repository.state.value);

  final ShopRepository _repository;

  final Computed<ShopState> state;

  void load() => _repository.load();

  List<ShopItemModel> get banners => _filter(ShopItemType.banner);

  List<ShopItemModel> get avatars => _filter(ShopItemType.avatar);

  List<ShopItemModel> get characters => _filter(ShopItemType.character);

  List<ShopItemModel> _filter(ShopItemType type) {
    final s = state.value;
    if (s is! ShopStateLoaded) {
      return [];
    }
    return s.catalogue.where((i) => i.type == type).toList();
  }

  bool hasPurchased(ShopCatalogItemId itemId) {
    final s = state.value;
    if (s is! ShopStateLoaded) {
      return false;
    }
    return s.purchasedItems.contains(itemId);
  }

  void requestPurchase(ShopItemModel item) {
    final s = state.value;
    if (s is! ShopStateLoaded) {
      return;
    }
    if (s.purchasedItems.contains(item.id)) {
      return;
    }
    if (s.balance < item.price) {
      return;
    }
    _repository.requestPurchase(item.id);
  }
}

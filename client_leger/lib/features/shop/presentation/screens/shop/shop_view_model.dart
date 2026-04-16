import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/enums/shop_catalog_item_id.dart';
import '../../../../../core/enums/shop_item_type.dart';
import '../../../../profile/data/models/dto/profile_dto.dart';
import '../../../../profile/data/services/http_profile_service.dart';
import '../../../data/repositories/shop_repository.dart';
import '../../../domain/models/shop_item_model.dart';
import '../../../domain/state/shop_state.dart';

enum BannerEquipOutcome { equipped, unequipped }

class ShopViewModel {
  ShopViewModel({
    required ShopRepository repository,
    required HttpProfileService profileService,
  }) : _repository = repository,
       _profileService = profileService,
       state = computed(() => repository.state.value);

  final ShopRepository _repository;
  final HttpProfileService _profileService;

  final Computed<ShopState> state;

  /// Wire value of the active banner id from profile preferences, or null.
  final Signal<String?> activeBannerWire = signal(null);

  void load() {
    _repository.load();
    unawaited(_refreshActiveBannerPreference());
  }

  Future<void> _refreshActiveBannerPreference() async {
    try {
      final profile = await _profileService.fetchProfile();
      final raw = profile.preferences['activeBanner'];
      activeBannerWire.value = raw is String && raw.isNotEmpty ? raw : null;
    } on Object {
      activeBannerWire.value = null;
    }
  }

  bool isBannerEquipped(ShopItemModel item) {
    if (item.type != ShopItemType.banner) {
      return false;
    }
    return activeBannerWire.value == item.id.wireValue;
  }

  Future<BannerEquipOutcome?> toggleBannerEquip(ShopItemModel item) async {
    if (item.type != ShopItemType.banner) {
      return null;
    }
    final profile = await _profileService.fetchProfile();
    final merged = Map<String, dynamic>.from(profile.preferences);
    final current = merged['activeBanner'] as String?;
    final wasEquipped = current == item.id.wireValue;
    merged['activeBanner'] = wasEquipped ? null : item.id.wireValue;
    await _profileService.updateProfile(
      ProfileUpdateRequestDto(preferences: merged),
    );
    activeBannerWire.value = wasEquipped ? null : item.id.wireValue;
    return wasEquipped ? BannerEquipOutcome.unequipped : BannerEquipOutcome.equipped;
  }

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

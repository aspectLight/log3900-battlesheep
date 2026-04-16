import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/enums/shop_catalog_item_id.dart';
import '../../domain/models/shop_item_model.dart';
import '../../domain/models/shop_socket_models.dart';
import '../../domain/state/shop_state.dart';
import '../services/shop_socket.dart';

class ShopRepository {
  ShopRepository({required ShopSocket shopSocket}) : _socket = shopSocket {
    _setupListeners();
  }

  final ShopSocket _socket;

  final Signal<ShopState> state = signal(const ShopState.loading());

  StreamSubscription<ShopCatalogModel>? _catalogueSub;
  StreamSubscription<ShopCurrencyModel>? _currencySub;
  StreamSubscription<int>? _balanceSub;
  StreamSubscription<ShopPurchaseModel>? _purchaseSub;

  void _setupListeners() {
    _catalogueSub = _socket.shopCatalogStream.listen(_applyCatalog);
    _currencySub = _socket.virtualCurrencyStream.listen(_applyCurrency);
    _balanceSub = _socket.balanceUpdatedStream.listen(_applyBalance);
    _purchaseSub = _socket.purchaseStream.listen(_applyPurchase);
  }

  /// Clears cached catalogue/balance (e.g. before session scope disposal or account switch).
  void resetToInitial() {
    state.value = const ShopState.loading();
  }

  void load() {
    state.value = const ShopState.loading();
    _socket.fetchBalance();
    _socket.fetchCatalogue();
  }

  void refreshBalance() {
    _socket.fetchBalance();
  }

  void refreshCatalogueAndBalance() {
    _socket.fetchBalance();
    _socket.fetchCatalogue();
  }

  void requestPurchase(ShopCatalogItemId itemId) =>
      _socket.purchaseItem(itemId.wireValue);

  void _applyCatalog(ShopCatalogModel model) {
    if (!model.success) {
      return;
    }
    final balance = switch (state.value) {
      ShopStateLoaded(:final balance) => balance,
      _ => 0,
    };
    state.value = ShopState.loaded(
      catalogue: List<ShopItemModel>.unmodifiable(model.catalogue),
      purchasedItems: List<ShopCatalogItemId>.unmodifiable(
        model.purchasedItems,
      ),
      balance: balance,
    );
  }

  void _applyCurrency(ShopCurrencyModel model) {
    if (!model.success) {
      return;
    }
    final balance = model.balance ?? 0;
    switch (state.value) {
      case final ShopStateLoaded s:
        state.value = s.copyWith(balance: balance);
      case ShopStateLoading():
        state.value = ShopState.loaded(
          catalogue: const [],
          purchasedItems: const [],
          balance: balance,
        );
    }
  }

  void _applyBalance(int b) {
    switch (state.value) {
      case final ShopStateLoaded s:
        state.value = s.copyWith(balance: b);
      case ShopStateLoading():
        state.value = ShopState.loaded(
          catalogue: const [],
          purchasedItems: const [],
          balance: b,
        );
    }
  }

  void _applyPurchase(ShopPurchaseModel model) {
    if (!model.success || model.newBalance == null) {
      return;
    }
    final current = state.value;
    if (current is! ShopStateLoaded) {
      return;
    }
    state.value = current.copyWith(
      balance: model.newBalance!,
      purchasedItems: List<ShopCatalogItemId>.unmodifiable(
        model.purchasedItems,
      ),
    );
  }

  void dispose() {
    unawaited(_catalogueSub?.cancel());
    unawaited(_currencySub?.cancel());
    unawaited(_balanceSub?.cancel());
    unawaited(_purchaseSub?.cancel());
  }
}

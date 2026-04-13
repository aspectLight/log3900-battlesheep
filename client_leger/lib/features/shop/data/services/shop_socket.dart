import 'dart:async';

import '../../../../core/services/socket_service.dart';
import '../../domain/models/shop_socket_models.dart';
import '../models/dto/currency_response_dto.dart';
import '../models/dto/purchase_item_request_dto.dart';
import '../models/dto/purchase_response_dto.dart';
import '../models/dto/shop_catalog_response_dto.dart';
import '../models/events/shop_socket_events.dart';
import '../models/extensions/currency_response_dto_ext.dart';
import '../models/extensions/purchase_response_dto_ext.dart';
import '../models/extensions/shop_catalog_response_dto_ext.dart';
import '../models/extensions/socket_raw_ext.dart';

class ShopSocket {
  ShopSocket({required SocketService socketService}) : _socketService = socketService {
    _connectionSubscription = _socketService.connectionStream.listen((connected) {
      if (!connected) {
        return;
      }
      _setupListeners();
    });
    if (_socketService.isConnected) {
      _setupListeners();
    }
  }

  final SocketService _socketService;

  static const List<String> _ownedEvents = [
    ShopSocketEvents.shopCatalogResponse,
    ShopSocketEvents.virtualCurrencyResponse,
    ShopSocketEvents.virtualCurrencyUpdated,
    ShopSocketEvents.purchaseItemResponse,
  ];

  final _shopCatalogController = StreamController<ShopCatalogModel>.broadcast();
  final _virtualCurrencyController =
      StreamController<ShopCurrencyModel>.broadcast();
  final _balanceUpdatedController = StreamController<int>.broadcast();
  final _purchaseController = StreamController<ShopPurchaseModel>.broadcast();

  StreamSubscription<bool>? _connectionSubscription;
  final List<StreamSubscription<dynamic>> _eventSubscriptions = [];

  Stream<ShopCatalogModel> get shopCatalogStream => _shopCatalogController.stream;

  Stream<ShopCurrencyModel> get virtualCurrencyStream =>
      _virtualCurrencyController.stream;

  Stream<int> get balanceUpdatedStream => _balanceUpdatedController.stream;

  Stream<ShopPurchaseModel> get purchaseStream => _purchaseController.stream;

  void _setupListeners() {
    _cancelEventListeners();
    _eventSubscriptions.addAll([
      _jsonObjectStream(ShopSocketEvents.shopCatalogResponse)
          .map((json) => ShopCatalogResponseDto.fromJson(json).toModel())
          .listen(_shopCatalogController.add),
      _jsonObjectStream(ShopSocketEvents.virtualCurrencyResponse)
          .map((json) => CurrencyResponseDto.fromJson(json).toModel())
          .listen(_virtualCurrencyController.add),
      _jsonObjectStream(ShopSocketEvents.virtualCurrencyUpdated)
          .map((json) => json.readBalance())
          .where((b) => b != null)
          .cast<int>()
          .listen(_balanceUpdatedController.add),
      _jsonObjectStream(ShopSocketEvents.purchaseItemResponse)
          .map((json) => PurchaseResponseDto.fromJson(json).toModel())
          .listen(_purchaseController.add),
    ]);
  }

  void _cancelEventListeners() {
    for (final sub in _eventSubscriptions) {
      unawaited(sub.cancel());
    }
    _eventSubscriptions.clear();
  }

  Stream<Map<String, dynamic>> _jsonObjectStream(String event) => _socketService
      .on<Object?>(event)
      .map((raw) => raw.asJsonMap())
      .where((m) => m != null)
      .cast<Map<String, dynamic>>();

  void fetchBalance() {
    _socketService.emit(ShopSocketEvents.getVirtualCurrency);
  }

  void fetchCatalogue() {
    _socketService.emit(ShopSocketEvents.getShopCatalog);
  }

  void purchaseItem(String itemId) {
    final payload = PurchaseItemRequestDto(itemId: itemId);
    _socketService.emit(ShopSocketEvents.purchaseItem, payload.toJson());
  }

  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
    for (final subscription in _eventSubscriptions) {
      await subscription.cancel();
    }
    _eventSubscriptions.clear();
    _ownedEvents.forEach(_socketService.off);
    await _shopCatalogController.close();
    await _virtualCurrencyController.close();
    await _balanceUpdatedController.close();
    await _purchaseController.close();
  }
}

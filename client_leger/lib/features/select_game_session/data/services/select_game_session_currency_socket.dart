import 'dart:async';

import '../../../../core/services/socket_service.dart';
import '../models/events/select_game_session_currency_socket_events.dart';
import '../models/extensions/select_game_session_socket_raw_ext.dart';

class SelectGameSessionCurrencySocket {
  SelectGameSessionCurrencySocket({required SocketService socketService})
    : _socketService = socketService {
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
    SelectGameSessionCurrencySocketEvents.virtualCurrencyResponse,
    SelectGameSessionCurrencySocketEvents.virtualCurrencyUpdated,
  ];

  final _currencyResponseController =
      StreamController<SelectGameSessionCurrencyResponse>.broadcast();
  final _balanceUpdatedController = StreamController<int>.broadcast();

  StreamSubscription<bool>? _connectionSubscription;
  final List<StreamSubscription<dynamic>> _eventSubscriptions = [];

  Stream<SelectGameSessionCurrencyResponse> get currencyResponseStream =>
      _currencyResponseController.stream;

  Stream<int> get balanceUpdatedStream => _balanceUpdatedController.stream;

  void _setupListeners() {
    _cancelEventListeners();
    _eventSubscriptions.addAll([
      _jsonObjectStream(SelectGameSessionCurrencySocketEvents.virtualCurrencyResponse)
          .map(SelectGameSessionCurrencyResponse.fromJson)
          .listen(_currencyResponseController.add),
      _jsonObjectStream(SelectGameSessionCurrencySocketEvents.virtualCurrencyUpdated)
          .map((json) => json.readBalance())
          .where((b) => b != null)
          .cast<int>()
          .listen(_balanceUpdatedController.add),
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
    _socketService.emit(SelectGameSessionCurrencySocketEvents.getVirtualCurrency);
  }

  Future<void> dispose() async {
    await _connectionSubscription?.cancel();
    for (final subscription in _eventSubscriptions) {
      await subscription.cancel();
    }
    _eventSubscriptions.clear();
    _ownedEvents.forEach(_socketService.off);
    await _currencyResponseController.close();
    await _balanceUpdatedController.close();
  }
}

class SelectGameSessionCurrencyResponse {
  const SelectGameSessionCurrencyResponse({
    required this.success,
    this.balance,
  });

  final bool success;
  final int? balance;

  factory SelectGameSessionCurrencyResponse.fromJson(Map<String, dynamic> json) {
    return SelectGameSessionCurrencyResponse(
      success: json['success'] as bool? ?? false,
      balance: (json['balance'] as num?)?.toInt(),
    );
  }
}

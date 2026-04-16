import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/services/socket_service.dart';
import '../services/select_game_session_currency_socket.dart';

class SelectGameSessionCurrencyRepository {
  SelectGameSessionCurrencyRepository({
    required SelectGameSessionCurrencySocket socket,
    required SocketService socketService,
  }) : _socket = socket,
       _socketService = socketService {
    _subs.add(_socket.currencyResponseStream.listen(_onCurrencyResponse));
    _subs.add(_socket.balanceUpdatedStream.listen(_onBalanceUpdated));
    _subs.add(_socketService.connectionStream.listen(_onConnectionChanged));
  }

  final SelectGameSessionCurrencySocket _socket;
  final SocketService _socketService;
  final List<StreamSubscription<dynamic>> _subs = [];

  final Signal<int> balance = signal<int>(0);

  void refreshBalance() {
    _socket.fetchBalance();
  }

  void resetBalance() {
    balance.value = 0;
  }

  void _onCurrencyResponse(SelectGameSessionCurrencyResponse response) {
    if (!response.success) {
      return;
    }
    final b = response.balance;
    if (b != null) {
      balance.value = b;
    }
  }

  void _onBalanceUpdated(int value) {
    balance.value = value;
  }

  void _onConnectionChanged(bool connected) {
    resetBalance();
  }

  void dispose() {
    for (final sub in _subs) {
      unawaited(sub.cancel());
    }
    _subs.clear();
  }
}

import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../services/select_game_session_currency_socket.dart';

class SelectGameSessionCurrencyRepository {
  SelectGameSessionCurrencyRepository({
    required SelectGameSessionCurrencySocket socket,
  }) : _socket = socket {
    _subs.add(
      _socket.currencyResponseStream.listen(_onCurrencyResponse),
    );
    _subs.add(
      _socket.balanceUpdatedStream.listen(_onBalanceUpdated),
    );
  }

  final SelectGameSessionCurrencySocket _socket;
  final List<StreamSubscription<dynamic>> _subs = [];

  final Signal<int> balance = signal<int>(0);

  void refreshBalance() {
    _socket.fetchBalance();
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
}

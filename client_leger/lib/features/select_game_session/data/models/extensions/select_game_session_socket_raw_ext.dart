extension SelectGameSessionSocketRawExt on Object? {
  Map<String, dynamic>? asJsonMap() {
    final raw = this;
    if (raw == null) {
      return null;
    }
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }
}

extension SelectGameSessionJsonMapBalanceExt on Map<String, dynamic> {
  int? readBalance() {
    final balance = this['balance'];
    if (balance is int) {
      return balance;
    }
    if (balance is num) {
      return balance.toInt();
    }
    return null;
  }
}

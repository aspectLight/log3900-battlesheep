import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

class ChatScopeHolder {
  ChatScopeHolder() : isChatAvailable = signal(false);

  final Signal<bool> isChatAvailable;

  GetIt? _scope;
  GetIt? get scope => _scope;

  void setScope(GetIt scope) {
    _scope = scope;
    isChatAvailable.value = true;
  }

  void clearScope() {
    _scope = null;
    isChatAvailable.value = false;
  }
}

import 'package:event_bus/event_bus.dart';

import '../exceptions/select_game_session_failure.dart';

class SelectGameSessionEventBus {
  SelectGameSessionEventBus(EventBus bus) : _bus = bus;

  final EventBus _bus;

  void fire<T>(T event) {
    _bus.fire(event);
  }

  Stream<T> on<T>() => _bus.on<T>();
}

class ConfirmSelectionFailed {
  final SelectGameSessionFailure failure;

  const ConfirmSelectionFailed(this.failure);
}

import 'package:event_bus/event_bus.dart';

import '../exceptions/join_game_session_failure.dart';

class JoinGameSessionEventBus {
  JoinGameSessionEventBus(EventBus bus) : _bus = bus;

  final EventBus _bus;

  void fire<T>(T event) {
    _bus.fire(event);
  }

  Stream<T> on<T>() => _bus.on<T>();
}

class JoinGameSessionFailureEvent {
  const JoinGameSessionFailureEvent(this.failure);

  final JoinGameSessionFailure failure;
}

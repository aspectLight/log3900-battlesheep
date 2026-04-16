import 'package:event_bus/event_bus.dart';

class ChatEventBus {
  ChatEventBus(EventBus bus) : _bus = bus;

  final EventBus _bus;

  void fire<T>(T event) {
    _bus.fire(event);
  }

  Stream<T> on<T>() => _bus.on<T>();
}

class ChatVerticalShakeDetected {
  const ChatVerticalShakeDetected();
}

class ChatHorizontalShakeDetected {
  const ChatHorizontalShakeDetected();
}

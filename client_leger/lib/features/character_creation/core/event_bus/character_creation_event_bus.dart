import 'package:event_bus/event_bus.dart';

import '../exceptions/reserve_character_failure.dart';

class CharacterCreationEventBus {
  CharacterCreationEventBus(EventBus bus) : _bus = bus;

  final EventBus _bus;

  void fire<T>(T event) {
    _bus.fire(event);
  }

  Stream<T> on<T>() => _bus.on<T>();
}

class CharacterCreationReserveFailedEvent {
  const CharacterCreationReserveFailedEvent(this.failure);

  final ReserveCharacterFailure failure;
}

class CharacterCreationRoomLockedEvent {
  const CharacterCreationRoomLockedEvent();
}

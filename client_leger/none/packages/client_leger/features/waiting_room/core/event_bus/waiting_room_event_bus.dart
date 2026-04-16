import 'package:event_bus/event_bus.dart';

import '../exceptions/waiting_room_failure.dart';

class WaitingRoomEventBus {
  WaitingRoomEventBus(EventBus bus) : _bus = bus;

  final EventBus _bus;

  void fire<T>(T event) {
    _bus.fire(event);
  }

  Stream<T> on<T>() => _bus.on<T>();
}

class WaitingRoomCanceledEvent {
  const WaitingRoomCanceledEvent();
}

class WaitingRoomPlayerKickedEvent {
  const WaitingRoomPlayerKickedEvent();
}

class WaitingRoomReserveFailedEvent {
  const WaitingRoomReserveFailedEvent(this.failure);

  final WaitingRoomFailure failure;
}

class WaitingRoomConfirmLeaveRequestedEvent {
  const WaitingRoomConfirmLeaveRequestedEvent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomConfirmKickRequestedEvent {
  const WaitingRoomConfirmKickRequestedEvent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomConfirmUnlockRequestedEvent {
  const WaitingRoomConfirmUnlockRequestedEvent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomSelectVirtualProfileRequestedEvent {
  const WaitingRoomSelectVirtualProfileRequestedEvent({
    required this.onAggressiveAction,
    required this.onDefensiveAction,
  });

  final void Function() onAggressiveAction;
  final void Function() onDefensiveAction;
}

class WaitingRoomRoomLockedNotificationRequestedEvent {
  const WaitingRoomRoomLockedNotificationRequestedEvent({
    required this.onDismissAction,
  });

  final void Function() onDismissAction;
}

class WaitingRoomFailureNotificationRequestedEvent {
  const WaitingRoomFailureNotificationRequestedEvent(this.failure);

  final WaitingRoomFailure failure;
}

class WaitingRoomWelcomeRequestedEvent {
  const WaitingRoomWelcomeRequestedEvent();
}

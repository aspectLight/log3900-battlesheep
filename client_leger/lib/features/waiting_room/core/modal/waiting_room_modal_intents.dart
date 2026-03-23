import '../../../../core/modal/modal_intent.dart';

class WaitingRoomConfirmLeaveModalIntent extends ModalIntent {
  const WaitingRoomConfirmLeaveModalIntent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomConfirmKickModalIntent extends ModalIntent {
  const WaitingRoomConfirmKickModalIntent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomConfirmUnlockModalIntent extends ModalIntent {
  const WaitingRoomConfirmUnlockModalIntent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomSelectVirtualProfileModalIntent extends ModalIntent {
  const WaitingRoomSelectVirtualProfileModalIntent({
    required this.onAggressiveAction,
    required this.onDefensiveAction,
  });

  final void Function() onAggressiveAction;
  final void Function() onDefensiveAction;
}

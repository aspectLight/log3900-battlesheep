import 'package:fpdart/fpdart.dart';

import '../../features/character_creation/core/enums/character_creation_validation_error.dart';
import '../../features/character_creation/core/exceptions/reserve_character_failure.dart';
import '../../features/join_game_session/core/exceptions/join_game_session_failure.dart';
import '../../features/select_game_session/core/exceptions/select_game_session_failure.dart';
import '../../features/shop/core/exceptions/shop_purchase_exception.dart';
import '../../features/waiting_room/core/exceptions/waiting_room_failure.dart';
import '../enums/item_type.dart';

sealed class NotificationIntent {
  const NotificationIntent();

  bool get persistOnExit => false;

  void Function()? get onDismissAction => null;
}

class TurnStartNotificationIntent extends NotificationIntent {
  final String playerName;
  final int countdownSeconds;

  const TurnStartNotificationIntent({
    required this.playerName,
    required this.countdownSeconds,
  });
}

class FinishGameNotificationIntent extends NotificationIntent {
  @override
  bool get persistOnExit => true;

  final String winnerId;
  final String winnerName;
  final String winnerTeamName;
  final bool isCTF;
  final String currentUserSocketId;
  final void Function()? onComplete;

  const FinishGameNotificationIntent({
    required this.winnerId,
    required this.winnerName,
    required this.winnerTeamName,
    required this.isCTF,
    required this.currentUserSocketId,
    this.onComplete,
  });
}

class GameAbandonedNotificationIntent extends NotificationIntent {
  @override
  bool get persistOnExit => true;

  final void Function()? onComplete;

  const GameAbandonedNotificationIntent({this.onComplete});
}

class GameCanceledNotificationIntent extends NotificationIntent {
  @override
  bool get persistOnExit => true;

  final void Function()? onComplete;

  const GameCanceledNotificationIntent({this.onComplete});
}

class InventoryFullDiscardIntent extends NotificationIntent {
  final List<ItemType> candidateItems;
  final void Function(Option<ItemType>) onComplete;

  InventoryFullDiscardIntent({
    required this.candidateItems,
    required this.onComplete,
  });
}

class TrapChoiceIntent extends NotificationIntent {
  final bool canAvoid;
  final void Function(String choice) onChoice;

  TrapChoiceIntent({required this.canAvoid, required this.onChoice});
}

class JoinGameSessionFailureNotificationIntent extends NotificationIntent {
  const JoinGameSessionFailureNotificationIntent(this.failure);
  final JoinGameSessionFailure failure;
}

class SelectGameSessionErrorNotificationIntent extends NotificationIntent {
  final SelectGameSessionFailure failure;

  const SelectGameSessionErrorNotificationIntent(this.failure);
}

class CharacterCreationValidationNotificationIntent extends NotificationIntent {
  final CharacterCreationValidationError error;

  const CharacterCreationValidationNotificationIntent(this.error);
}

class CharacterCreationReserveFailedNotificationIntent
    extends NotificationIntent {
  final ReserveCharacterFailure failure;

  const CharacterCreationReserveFailedNotificationIntent(this.failure);
}

class CharacterCreationRoomLockedNotificationIntent extends NotificationIntent {
  const CharacterCreationRoomLockedNotificationIntent({this.onDismissAction});

  @override
  final void Function()? onDismissAction;
}

class WaitingRoomReserveFailedNotificationIntent extends NotificationIntent {
  final WaitingRoomFailure failure;

  const WaitingRoomReserveFailedNotificationIntent(this.failure);
}

class WaitingRoomDeletedNotificationIntent extends NotificationIntent {
  const WaitingRoomDeletedNotificationIntent({this.onDismissAction});

  @override
  final void Function()? onDismissAction;
}

class WaitingRoomPlayerKickedNotificationIntent extends NotificationIntent {
  const WaitingRoomPlayerKickedNotificationIntent({this.onDismissAction});

  @override
  final void Function()? onDismissAction;
}

class WaitingRoomConfirmLeaveNotificationIntent extends NotificationIntent {
  const WaitingRoomConfirmLeaveNotificationIntent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomConfirmKickNotificationIntent extends NotificationIntent {
  const WaitingRoomConfirmKickNotificationIntent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomConfirmUnlockNotificationIntent extends NotificationIntent {
  const WaitingRoomConfirmUnlockNotificationIntent({
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final void Function() onConfirmAction;
  final void Function() onCancelAction;
}

class WaitingRoomSelectVirtualProfileNotificationIntent
    extends NotificationIntent {
  const WaitingRoomSelectVirtualProfileNotificationIntent({
    required this.onAggressiveAction,
    required this.onDefensiveAction,
  });

  final void Function() onAggressiveAction;
  final void Function() onDefensiveAction;
}

class WaitingRoomRoomLockedNotificationIntent extends NotificationIntent {
  const WaitingRoomRoomLockedNotificationIntent({
    required this.onDismissAction,
  });

  @override
  final void Function()? onDismissAction;
}

class WaitingRoomFailureNotificationIntent extends NotificationIntent {
  const WaitingRoomFailureNotificationIntent({required this.failure});

  final WaitingRoomFailure failure;
}

class WaitingRoomWelcomeNotificationIntent extends NotificationIntent {
  const WaitingRoomWelcomeNotificationIntent();
}

class ShopPurchaseFailedNotificationIntent extends NotificationIntent {
  const ShopPurchaseFailedNotificationIntent(this.failure);

  final ShopPurchaseException failure;
}

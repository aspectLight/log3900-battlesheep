import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../../../../core/enums/item_type.dart';
import '../../../../../core/notification/notification_coordinator.dart';
import '../../../../../core/notification/notification_intent.dart';

class GameInventoryFullDiscardNotificationViewModel {
  final NotificationCoordinator _coordinator;

  GameInventoryFullDiscardNotificationViewModel(this._coordinator);

  Future<Option<ItemType>> show(List<ItemType> candidateItems) {
    final completer = Completer<Option<ItemType>>();
    void handleDiscardComplete(Option<ItemType> discardedItemType) {
      if (!completer.isCompleted) completer.complete(discardedItemType);
    }

    _coordinator.addIntent(
      InventoryFullDiscardIntent(
        candidateItems: candidateItems,
        onComplete: handleDiscardComplete,
      ),
    );
    return completer.future;
  }
}

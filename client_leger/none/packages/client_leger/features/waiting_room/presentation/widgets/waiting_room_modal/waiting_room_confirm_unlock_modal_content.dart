import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/modal/waiting_room_modal_intents.dart';
import '../waiting_room_confirm_unlock_notification/waiting_room_confirm_unlock_notification_widget.dart';

class WaitingRoomConfirmUnlockModalContent extends StatelessWidget {
  const WaitingRoomConfirmUnlockModalContent({
    super.key,
    required this.intent,
    required this.onClose,
  });

  final WaitingRoomConfirmUnlockModalIntent intent;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return WaitingRoomConfirmUnlockNotificationWidget(
      intent: WaitingRoomConfirmUnlockNotificationIntent(
        onConfirmAction: () {
          intent.onConfirmAction();
          onClose();
        },
        onCancelAction: () {
          intent.onCancelAction();
          onClose();
        },
      ),
      onDismiss: onClose,
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/modal/waiting_room_modal_intents.dart';
import '../waiting_room_confirm_kick_notification/waiting_room_confirm_kick_notification_widget.dart';

class WaitingRoomConfirmKickModalContent extends StatelessWidget {
  const WaitingRoomConfirmKickModalContent({
    super.key,
    required this.intent,
    required this.onClose,
  });

  final WaitingRoomConfirmKickModalIntent intent;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return WaitingRoomConfirmKickNotificationWidget(
      intent: WaitingRoomConfirmKickNotificationIntent(
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

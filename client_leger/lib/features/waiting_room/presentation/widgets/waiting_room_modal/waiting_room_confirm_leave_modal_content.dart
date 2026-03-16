import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/modal/waiting_room_modal_intents.dart';
import '../waiting_room_confirm_leave_notification/waiting_room_confirm_leave_notification_widget.dart';

class WaitingRoomConfirmLeaveModalContent extends StatelessWidget {
  const WaitingRoomConfirmLeaveModalContent({
    super.key,
    required this.intent,
    required this.onClose,
  });

  final WaitingRoomConfirmLeaveModalIntent intent;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return WaitingRoomConfirmLeaveNotificationWidget(
      intent: WaitingRoomConfirmLeaveNotificationIntent(
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

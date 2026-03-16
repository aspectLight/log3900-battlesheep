import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/modal/waiting_room_modal_intents.dart';
import '../waiting_room_select_virtual_profile_notification/waiting_room_select_virtual_profile_notification_widget.dart';

class WaitingRoomSelectVirtualProfileModalContent extends StatelessWidget {
  const WaitingRoomSelectVirtualProfileModalContent({
    super.key,
    required this.intent,
    required this.onClose,
  });

  final WaitingRoomSelectVirtualProfileModalIntent intent;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return WaitingRoomSelectVirtualProfileNotificationWidget(
      intent: WaitingRoomSelectVirtualProfileNotificationIntent(
        onAggressiveAction: () {
          intent.onAggressiveAction();
          onClose();
        },
        onDefensiveAction: () {
          intent.onDefensiveAction();
          onClose();
        },
      ),
      onDismiss: onClose,
    );
  }
}

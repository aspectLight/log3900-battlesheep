import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/waiting_room_localizations.dart';
import 'waiting_room_room_locked_notification_view_model.dart';

class WaitingRoomRoomLockedNotificationWidget extends StatelessWidget {
  WaitingRoomRoomLockedNotificationWidget({
    super.key,
    required WaitingRoomRoomLockedNotificationIntent intent,
    required VoidCallback onDismiss,
  }) : _viewModel = WaitingRoomRoomLockedNotificationViewModel(
         intent: intent,
         onDismiss: onDismiss,
       );

  final WaitingRoomRoomLockedNotificationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = WaitingRoomLocalizations.of(context)!;
    return _InfoShell(
      message: l10n.waitingRoomRoomLocked,
      buttonLabel: l10n.ok,
      onDismiss: _viewModel.handleDismiss,
    );
  }
}

class _InfoShell extends StatelessWidget {
  const _InfoShell({
    required this.message,
    required this.buttonLabel,
    required this.onDismiss,
  });

  final String message;
  final String buttonLabel;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 30,
                  offset: Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF550000),
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                    letterSpacing: 0.5,
                    fontFamily: 'CustomFont',
                  ),
                ),
                const SizedBox(height: 24),
                _ActionButton(label: buttonLabel, onTap: onDismiss),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF550000),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF7F1F1F)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33550000),
                blurRadius: 6,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFFFF0F0),
              fontWeight: FontWeight.w500,
              fontSize: 15,
              letterSpacing: 0.5,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
      ),
    );
  }
}

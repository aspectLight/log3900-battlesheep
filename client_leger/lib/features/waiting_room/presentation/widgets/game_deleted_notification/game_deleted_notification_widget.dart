import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/waiting_room_localizations.dart';
import 'game_deleted_notification_view_model.dart';

class GameDeletedNotificationWidget extends StatelessWidget {
  GameDeletedNotificationWidget({
    super.key,
    required WaitingRoomDeletedNotificationIntent intent,
    required VoidCallback onDismiss,
  }) : _viewModel = GameDeletedNotificationViewModel(
          intent: intent,
          onDismiss: onDismiss,
        );

  final GameDeletedNotificationViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    final l10n = WaitingRoomLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
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
                  l10n.gameNotFound,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF550000),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    fontFamily: 'CustomFont',
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _GameButton(label: l10n.ok, onTap: _viewModel.handleDismiss),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GameButton extends StatelessWidget {
  const _GameButton({required this.label, required this.onTap});

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
            border: Border.all(color: const Color(0xFF7f1f1f)),
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
              color: Color(0xFFfff0f0),
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              fontSize: 15,
              fontFamily: 'CustomFont',
            ),
          ),
        ),
      ),
    );
  }
}

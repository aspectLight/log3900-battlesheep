import 'package:flutter/material.dart';

import '../../../../../core/appearance/app_feature_colors.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/waiting_room_localizations.dart';

class WaitingRoomWelcomeNotificationWidget extends StatelessWidget {
  const WaitingRoomWelcomeNotificationWidget({
    super.key,
    // ignore: avoid_unused_constructor_parameters
    required WaitingRoomWelcomeNotificationIntent intent,
    required VoidCallback onDismiss,
  }) : _onDismiss = onDismiss;

  final VoidCallback _onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = WaitingRoomLocalizations.of(context)!;
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
                  l10n.waitingRoomWelcomeMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: context.featureColors.bgButton,
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    letterSpacing: 0.5,
                    fontFamily: 'CustomFont',
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 24),
                _WelcomeActionButton(label: l10n.ok, onTap: _onDismiss),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeActionButton extends StatelessWidget {
  const _WelcomeActionButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final f = context.featureColors;
    return Material(
      color: f.bgButton,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: f.borderButton),
            boxShadow: [
              BoxShadow(
                color: f.shadowAccent,
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              color: f.textSpecialAlt,
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

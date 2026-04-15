import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/game_session_localizations.dart';

class GameTrapChoiceNotificationWidget extends StatelessWidget {
  final TrapChoiceIntent intent;
  final VoidCallback onDismiss;

  const GameTrapChoiceNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = GameSessionLocalizations.of(context)!;

    return ColoredBox(
      color: Colors.black.withValues(alpha: 0.65),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.gameTrapTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF550000),
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  letterSpacing: 0.5,
                  fontFamily: 'CustomFont',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                intent.canAvoid
                    ? l10n.gameTrapDescriptionCanAvoid
                    : l10n.gameTrapDescriptionMustTraverse,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 16,
                  fontFamily: 'CustomFont',
                ),
              ),
              const SizedBox(height: 20),
              if (intent.canAvoid) ...[
                SizedBox(
                  width: double.infinity,
                  child: _TrapButton(
                    label: l10n.gameTrapAvoid,
                    onPressed: () {
                      intent.onChoice('avoid');
                      onDismiss();
                    },
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: _TrapButton(
                  label: l10n.gameTrapTraverse,
                  onPressed: () {
                    intent.onChoice('traverse');
                    onDismiss();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrapButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _TrapButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF550000),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF7F1F1F)),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFFFFF0F0),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                fontFamily: 'CustomFont',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

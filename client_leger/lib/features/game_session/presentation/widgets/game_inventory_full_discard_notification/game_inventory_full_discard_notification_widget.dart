import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/enums/item_type.dart';
import '../../../core/extensions/item_type_ext.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/game_session_localizations.dart';

class GameInventoryFullDiscardNotificationWidget extends StatelessWidget {
  final InventoryFullDiscardIntent intent;
  final VoidCallback onDismiss;

  const GameInventoryFullDiscardNotificationWidget({
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
                l10n.gameInventoryFullDiscardTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF550000),
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  letterSpacing: 0.5,
                  fontFamily: 'CustomFont',
                ),
              ),
              const SizedBox(height: 20),
              ...intent.candidateItems.map(
                (ItemType itemType) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: SizedBox(
                    width: double.infinity,
                    child: _DiscardButton(
                      label: itemType.getName(l10n),
                      onPressed: () {
                        intent.onComplete(Option.of(itemType));
                        onDismiss();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscardButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _DiscardButton({required this.label, required this.onPressed});

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
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF550000).withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 4),
              ),
            ],
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

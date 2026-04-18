import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/game_session_localizations.dart';

/// Matches the web main-page [app-pop-up] for game canceled / left (no countdown,
/// themed surface card, accent title, single dismiss like `common.understood`).
class GameCanceledNotificationWidget extends StatelessWidget {
  final GameCanceledNotificationIntent intent;
  final VoidCallback onDismiss;

  const GameCanceledNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = GameSessionLocalizations.of(context)!;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final message = intent.isSelfLeave
        ? l10n.notificationGameLeft
        : l10n.notificationGameCanceled;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: ColoredBox(color: Colors.black.withValues(alpha: 0.55)),
            ),
          ),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          message.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            fontFamily: 'CustomFont',
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            intent.onComplete?.call();
                            onDismiss();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 48),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 28,
                              vertical: 12,
                            ),
                          ),
                          child: Text(l10n.gameSessionPopupUnderstood),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../../../../core/notification/notification_shell.dart';
import 'combat_started_notification_view_model.dart';

class CombatStartedNotificationWidget extends StatefulWidget {
  final CombatStartedNotificationIntent intent;
  final void Function() onDismiss;

  const CombatStartedNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  @override
  State<CombatStartedNotificationWidget> createState() =>
      _CombatStartedNotificationWidgetState();
}

class _CombatStartedNotificationWidgetState
    extends State<CombatStartedNotificationWidget> {
  late final CombatStartedNotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CombatStartedNotificationViewModel(
      intent: widget.intent,
      onDismiss: widget.onDismiss,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = GameSessionLocalizations.of(context)!;
    return GestureDetector(
      onTap: _viewModel.dismiss,
      child: NotificationShell(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.combatStartedNotificationTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.combatStartedNotificationMessage(
                widget.intent.attackerName,
                widget.intent.defenderName,
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'CustomFont',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

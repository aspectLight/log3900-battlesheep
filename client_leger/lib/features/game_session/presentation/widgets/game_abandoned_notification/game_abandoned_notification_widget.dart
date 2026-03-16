import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../../../../core/notification/notification_shell.dart';
import 'game_abandoned_notification_view_model.dart';

class GameAbandonedNotificationWidget extends StatefulWidget {
  final GameAbandonedNotificationIntent intent;
  final VoidCallback onDismiss;

  const GameAbandonedNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  @override
  State<GameAbandonedNotificationWidget> createState() =>
      _GameAbandonedNotificationWidgetState();
}

class _GameAbandonedNotificationWidgetState
    extends State<GameAbandonedNotificationWidget> {
  late final GameAbandonedNotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GameAbandonedNotificationViewModel(
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
    return NotificationShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.notificationGameAbandoned,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${_viewModel.remainingSeconds.watch(context)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      ),
    );
  }
}

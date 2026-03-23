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
          const SizedBox(height: 14),
          SizedBox(
            width: 180,
            child: ElevatedButton(
              onPressed: () {
                widget.intent.onComplete?.call();
                widget.onDismiss();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 85, 0, 0),
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                elevation: 0,
                side: const BorderSide(color: Color.fromARGB(255, 127, 31, 31)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                textStyle: const TextStyle(fontSize: 15, fontFamily: 'CustomFont'),
              ),
              child: Text(l10n.gameSessionInfoContinue),
            ),
          ),
        ],
      ),
    );
  }
}

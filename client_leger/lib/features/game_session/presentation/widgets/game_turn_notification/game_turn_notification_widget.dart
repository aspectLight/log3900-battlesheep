import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../../../../core/notification/notification_shell.dart';
import '../../../core/constants/game_turn_notification_constants.dart';
import 'game_turn_notification_view_model.dart';

class GameTurnNotificationWidget extends StatefulWidget {
  final TurnStartNotificationIntent intent;
  final VoidCallback onDismiss;

  const GameTurnNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  @override
  State<GameTurnNotificationWidget> createState() =>
      _GameTurnNotificationWidgetState();
}

class _GameTurnNotificationWidgetState
    extends State<GameTurnNotificationWidget> {
  late final GameTurnNotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GameTurnNotificationViewModel(
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
    final message = l10n.notificationTurnStart(
      widget.intent.playerName,
      GameTurnNotificationConstants.messageCountdownSeconds,
    );
    return NotificationShell(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth,
                maxHeight: constraints.maxHeight,
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'CustomFont',
                        decoration: TextDecoration.none,
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
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/notification/notification_intent.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../../../../core/notification/notification_shell.dart';
import 'game_finish_notification_view_model.dart';

class GameFinishNotificationWidget extends StatefulWidget {
  final FinishGameNotificationIntent intent;
  final VoidCallback onDismiss;

  const GameFinishNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  @override
  State<GameFinishNotificationWidget> createState() =>
      _GameFinishNotificationWidgetState();
}

class _GameFinishNotificationWidgetState
    extends State<GameFinishNotificationWidget> {
  late final GameFinishNotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GameFinishNotificationViewModel(
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
    final message = _viewModel.hasWon
        ? (widget.intent.isCTF
              ? l10n.notificationVictoryCtf
              : l10n.notificationVictoryClassic)
        : (widget.intent.isCTF
              ? (widget.intent.winnerTeamName.trim().isEmpty
                    ? l10n.notificationDefeatCtfUnknown
                    : l10n.notificationDefeatCtfKnown(
                        widget.intent.winnerTeamName,
                      ))
              : (widget.intent.winnerName.trim().isEmpty
                    ? l10n.notificationDefeatClassicUnknown
                    : l10n.notificationDefeatClassicKnown(
                        widget.intent.winnerName,
                      )));
    return NotificationShell(
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

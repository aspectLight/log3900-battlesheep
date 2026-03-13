import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/context/game_session_scope_holder.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../data/repositories/game_player_repository.dart';
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
    final scope = GetIt.I<GameSessionScopeHolder>().scope!;
    _viewModel = GameFinishNotificationViewModel(
      intent: widget.intent,
      onDismiss: widget.onDismiss,
      playerRepository: scope.get<GamePlayerRepository>(),
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
              ? l10n.notificationDefeatCtf(_viewModel.winnerTeamName)
              : l10n.notificationDefeatClassic(_viewModel.winnerName));
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

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/context/game_session_scope_holder.dart';
import '../../../../../core/notification/notification_intent.dart';
import '../../../data/repositories/game_player_repository.dart';
import '../../../core/localisation/game_session_localizations.dart';
import '../../../../../core/notification/notification_shell.dart';
import 'end_combat_notification_view_model.dart';

class EndCombatNotificationWidget extends StatefulWidget {
  final EndCombatNotificationIntent intent;
  final void Function() onDismiss;

  const EndCombatNotificationWidget({
    super.key,
    required this.intent,
    required this.onDismiss,
  });

  @override
  State<EndCombatNotificationWidget> createState() =>
      _EndCombatNotificationWidgetState();
}

class _EndCombatNotificationWidgetState
    extends State<EndCombatNotificationWidget> {
  late final EndCombatNotificationViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    final scope = GetIt.I<GameSessionScopeHolder>().scope!;
    _viewModel = EndCombatNotificationViewModel(
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
    return Watch((context) {
      final l10n = GameSessionLocalizations.of(context)!;
      final hasWon = _viewModel.hasWon.value;
      final hasLost = _viewModel.hasLost.value;
      final hasFled = _viewModel.hasFled.value;
      final String title;
      final String message;
      if (hasWon) {
        title = l10n.combatNotificationVictory;
        message = l10n.combatNotificationVictoryMessage;
      } else if (hasLost) {
        title = l10n.combatNotificationDefeat;
        message = l10n.combatNotificationDefeatMessage(
          _viewModel.winnerName.value,
        );
      } else if (hasFled) {
        title = l10n.combatNotificationFlightSuccessTitle;
        message = l10n.combatNotificationFlightSuccess;
      } else {
        title = l10n.combatNotificationFlightSuccessTitle;
        message = l10n.combatNotificationEnemyFled(_viewModel.enemyName.value);
      }
      return GestureDetector(
        onTap: _viewModel.dismiss,
        child: NotificationShell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
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
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'CustomFont',
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${_viewModel.remainingSeconds.watch(context)}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontFamily: 'CustomFont',
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

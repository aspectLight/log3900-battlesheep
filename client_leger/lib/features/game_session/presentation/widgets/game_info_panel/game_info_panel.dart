import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_interaction_colors.dart';
import '../../../core/context/game_session_scope_holder.dart';
import '../../../core/localisation/game_session_localizations.dart';
import 'game_info_panel_view_model.dart';

class GameInfoPanel extends StatelessWidget {
  const GameInfoPanel({
    super.key,
    required this.onClose,
  });

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scope = GetIt.I<GameSessionScopeHolder>().scope;
    if (scope == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final vm = scope.get<GameInfoPanelViewModel>();
    final l10n = GameSessionLocalizations.of(context)!;
    final model = vm.infoModel.watch(context);
    final scheme = Theme.of(context).colorScheme;
    final titleStyle = TextStyle(
      color: scheme.primary,
      fontSize: 22,
      fontWeight: FontWeight.bold,
      fontFamily: 'CustomFont',
      letterSpacing: 0.5,
      decoration: TextDecoration.none,
    );
    const descriptionStyle = TextStyle(
      color: Color(0xFF333333),
      fontSize: 16,
      fontFamily: 'CustomFont',
      height: 1.5,
      decoration: TextDecoration.none,
    );
    final pillButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: context.interactionColors.outline),
      ),
      elevation: 2,
      textStyle: const TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: 'CustomFont',
        letterSpacing: 0.5,
      ),
      minimumSize: const Size(100, 44),
    );
    return Center(
      child: Container(
        padding: const EdgeInsets.all(18),
        constraints: const BoxConstraints(maxWidth: 500),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              model.gameName.toUpperCase(),
              style: titleStyle,
              textAlign: TextAlign.center,
            ),
            if (model.gameDescription.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                model.gameDescription,
                style: descriptionStyle,
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            Text(
              '${l10n.gameSessionInfoPlayers}: ${model.playerCount}',
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              '${l10n.gameSessionInfoActivePlayer}: ${model.activePlayerName}',
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
            Text(
              '${l10n.gameSessionInfoBoardSize}: '
              '${model.boardSize}x${model.boardSize}',
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: ElevatedButton(
                    onPressed: () {
                      if (vm.canForwardTurn.value) vm.forwardTurn();
                      onClose();
                    },
                    style: pillButtonStyle,
                    child: Text(l10n.gameSessionInfoContinue),
                  ),
                ),
                const SizedBox(width: 16),
                Flexible(
                  child: ElevatedButton(
                    onPressed: () async {
                      await vm.leaveGame();
                      onClose();
                    },
                    style: pillButtonStyle,
                    child: Text(l10n.gameSessionInfoQuit),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

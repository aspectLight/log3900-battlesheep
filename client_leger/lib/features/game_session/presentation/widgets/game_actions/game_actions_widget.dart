import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/localisation/game_session_localizations.dart';
import 'game_actions_view_model.dart';

class GameActionsWidget extends StatefulWidget {
  const GameActionsWidget({super.key});

  @override
  State<GameActionsWidget> createState() => _GameActionsWidgetState();
}

class _GameActionsWidgetState extends State<GameActionsWidget> {
  late final GameActionsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GameActionsViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = GameSessionLocalizations.of(context)!;
    final isInActionMode = _viewModel.isInActionMode.watch(context);
    final canForwardTurn = _viewModel.canForwardTurn.watch(context);
    final isCurrentPlayerTurn = _viewModel.isCurrentPlayerTurn.watch(context);

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF444444)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 2,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          _ActionButton(
            label: isInActionMode ? l10n.gameActionCancel : l10n.gameActionAct,
            onTap: _viewModel.toggleActionModeOrReturnToSelection,
            enabled: isCurrentPlayerTurn,
          ),
          Container(width: 1, color: const Color(0xFF444444)),
          _ActionButton(
            label: l10n.gameActionForwardTurn,
            onTap: _viewModel.forwardTurn,
            enabled: canForwardTurn,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool enabled;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onTap : null,
          splashColor: const Color(0xFF550000).withValues(alpha: 0.3),
          highlightColor: const Color(0xFF550000).withValues(alpha: 0.1),
          child: Center(
            child: Opacity(
              opacity: enabled ? 1 : 0.5,
              child: Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CustomFont',
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

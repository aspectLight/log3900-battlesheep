import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_feature_colors.dart';
import '../../../core/context/game_session_scope_holder.dart';
import '../../../core/localisation/game_session_localizations.dart';
import 'game_debug_mode_strip_view_model.dart';

/// Fills height when placed in a [Row] with [CrossAxisAlignment.stretch].
class GameDebugModeStrip extends StatelessWidget {
  const GameDebugModeStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = GetIt.I<GameSessionScopeHolder>().scope;
    if (scope == null) return const SizedBox.shrink();
    final viewModel = scope.get<GameDebugModeStripViewModel>();
    final isDebugMode = viewModel.isDebugMode.watch(context);
    if (!isDebugMode) return const SizedBox.shrink();
    final l10n = GameSessionLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final f = context.featureColors;
    final fill = Color.alphaBlend(
      scheme.error.withValues(alpha: 0.22),
      f.panelInset,
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.error, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: scheme.error.withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          child: Text(
            l10n.gameDebugMode,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: scheme.error,
              fontWeight: FontWeight.w700,
              fontSize: 14,
              fontFamily: 'CustomFont',
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

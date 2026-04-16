import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/context/game_session_scope_holder.dart';
import '../../../core/localisation/game_session_localizations.dart';
import 'game_debug_mode_strip_view_model.dart';

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x99160707),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3A1212)),
      ),
      child: Text(
        l10n.gameDebugMode,
        style: const TextStyle(
          color: Color(0xFFFF6A6A),
          fontSize: 14,
          fontFamily: 'CustomFont',
        ),
      ),
    );
  }
}

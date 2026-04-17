import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_feature_colors.dart';
import '../../../core/localisation/game_session_localizations.dart';
import 'game_timer_view_model.dart';

enum GameTimerLayout {
  /// Centered under the board (legacy).
  standalone,

  /// Same typography as [standalone] surface; centered in the timer row / cell.
  bar,
}

class GameTimerWidget extends StatefulWidget {
  const GameTimerWidget({super.key, this.layout = GameTimerLayout.standalone});

  final GameTimerLayout layout;

  @override
  State<GameTimerWidget> createState() => _GameTimerWidgetState();
}

class _GameTimerWidgetState extends State<GameTimerWidget> {
  late final GameTimerViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<GameTimerViewModel>();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final seconds = _viewModel.countdownSeconds.watch(context);
    final l10n = GameSessionLocalizations.of(context)!;
    final f = context.featureColors;
    final text = Text(
      l10n.gameTimerCurrentTurn(seconds),
      style: TextStyle(
        color: widget.layout == GameTimerLayout.bar
            ? f.textSpecialAlt
            : Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.normal,
        fontFamily: 'CustomFont',
      ),
    );
    if (widget.layout == GameTimerLayout.bar) {
      return Center(child: text);
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: text,
      ),
    );
  }
}

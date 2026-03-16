import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/localisation/game_session_localizations.dart';
import 'game_timer_view_model.dart';

class GameTimerWidget extends StatefulWidget {
  const GameTimerWidget({super.key});

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          '${l10n.gameTimerLabel}: $seconds',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.normal,
            fontFamily: 'CustomFont',
          ),
        ),
      ),
    );
  }
}

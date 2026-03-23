import 'package:signals_flutter/signals_flutter.dart';

import '../../../data/repositories/game_turn_repository.dart';

class GameTimerViewModel {
  final GameTurnRepository _turnRepository;

  late final countdownSeconds = computed<int>(() {
    final turnState = _turnRepository.state.value;
    return turnState.turnCountdown;
  });

  GameTimerViewModel({required GameTurnRepository turnRepository})
    : _turnRepository = turnRepository;

  void dispose() {}
}

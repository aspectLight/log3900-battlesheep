import 'package:signals_flutter/signals_flutter.dart';

import '../../../data/repositories/game_combat_repository.dart';

class GameScreenViewModel {
  final GameCombatRepository _combatRepository;

  GameScreenViewModel({required GameCombatRepository combatRepository})
    : _combatRepository = combatRepository;

  late final isCombatMode = computed<bool>(() {
    return _combatRepository.state.value.isCombatMode;
  });
}

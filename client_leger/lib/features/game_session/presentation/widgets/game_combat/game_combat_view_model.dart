import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/helpers/functional_programming.dart';
import '../../../domain/commands/game_combat_commands.dart';
import '../../../data/repositories/game_combat_repository.dart';
import '../../../data/repositories/game_player_repository.dart';
import '../../../data/repositories/game_turn_repository.dart';
import '../../../domain/state/game_combat_state.dart';
import '../../mappers/game_combat_ui_mapper.dart';
import '../../ui_models/widget_states/game_combat_ui_state.dart';

class GameCombatViewModel {
  final GameCombatRepository _combatRepository;
  final GamePlayerRepository _playerRepository;
  final GameTurnRepository _turnRepository;
  final String _socketId;

  GameCombatViewModel({
    required GameCombatRepository combatRepository,
    required GamePlayerRepository playerRepository,
    required GameTurnRepository turnRepository,
    required String socketId,
  }) : _combatRepository = combatRepository,
       _playerRepository = playerRepository,
       _turnRepository = turnRepository,
       _socketId = socketId;

  GameCombatState get _combatState => _combatRepository.state.value;

  late final combatUiModel = computed<GameCombatUiState>(() {
    final playerState = _playerRepository.state.value;
    final turnState = _turnRepository.state.value;
    return toGameCombatUiModel(
      _combatState,
      playerState,
      turnState,
      _socketId,
    );
  });

  late final isCombatMode = computed<bool>(
    () => combatUiModel.value is GameCombatActive,
  );

  late final isCombatPlayerTurn = computed<bool>(() {
    final model = combatUiModel.value;
    return model is GameCombatActive && model.isCombatPlayerTurn;
  });

  late final combatCountdown = computed<int>(() {
    final model = combatUiModel.value;
    return model is GameCombatActive ? model.combatCountdown : 0;
  });

  late final flightAttemptsLeft = computed<int>(() {
    final model = combatUiModel.value;
    return model is GameCombatActive ? model.flightAttemptsLeft : 0;
  });

  late final canAttack = computed<bool>(() {
    final model = combatUiModel.value;
    return model is GameCombatActive && model.canAttack;
  });

  late final canFlee = computed<bool>(() {
    final model = combatUiModel.value;
    return model is GameCombatActive && model.canFlee;
  });

  late final showResults = computed<bool>(() {
    final model = combatUiModel.value;
    return model is GameCombatActive && model.showResults;
  });

  void attack() {
    if (!canAttack.value) return;
    _combatState.combatRoomId.whenPresent(
      (roomId) => _combatRepository.attack(AttackCommand(roomId: roomId)),
    );
  }

  void flightAttempt() {
    if (!canFlee.value) return;
    _combatState.combatRoomId.whenPresent(
      (roomId) => _combatRepository.flightAttempt(
        FlightAttemptCommand(roomId: roomId),
      ),
    );
  }

  void dispose() {}
}

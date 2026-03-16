import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/constants/game_rules_constants.dart';
import '../../../../core/enums/item_type.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../domain/commands/game_action_commands.dart';
import '../../domain/state/game_inventory_state.dart';
import '../../domain/state/game_player_state.dart';
import '../../domain/state/game_session_state.dart';
import '../repositories/game_actions_repository.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_inventory_repository.dart';
import '../repositories/game_metadata_repository.dart';
import '../repositories/game_player_repository.dart';

class GameWinConditionSideEffect with DisposableSideEffect {
  final String _roomId;
  final String _socketId;
  final GamePlayerRepository _playerRepository;
  final GameMetadataRepository _metadataRepository;
  final GameInventoryRepository _inventoryRepository;
  final GameBoardRepository _boardRepository;
  final GameActionsRepository _actionsRepository;

  GameWinConditionSideEffect({
    required String roomId,
    required String socketId,
    required GamePlayerRepository playerRepository,
    required GameInventoryRepository inventoryRepository,
    required GameBoardRepository boardRepository,
    required GameActionsRepository actionsRepository,
    required GameMetadataRepository metadataRepository,
  })  : _roomId = roomId,
        _socketId = socketId,
        _playerRepository = playerRepository,
        _metadataRepository = metadataRepository,
        _inventoryRepository = inventoryRepository,
        _boardRepository = boardRepository,
        _actionsRepository = actionsRepository {
    trackEffect(_finishGameIfWon);
  }

  late final _winnerId = computed<Option<String>>(() {
    final metadata = _metadataRepository.state.value;
    if (metadata is! GameSessionActive) {
      return const Option.none();
    }
    final playerState = _playerRepository.state.value;
    return metadata.isCTF
        ? _ctfWinnerId(playerState)
        : _combatWinnerId(metadata, playerState);
  });

  Option<String> _combatWinnerId(
    GameSessionActive session,
    GamePlayerState playerState,
  ) {
    for (final MapEntry(:key, :value) in playerState.winsByPlayerId.entries) {
      if (value < GameRulesConstants.requiredCombatWins) continue;
      final winnerOpt = playerState.findById(key);
      final shouldFinish = switch (winnerOpt) {
        None() => false,
        Some(value: final winner) =>
          _socketId == winner.id ||
          (winner.isVirtual && _socketId == session.hostId),
      };
      if (shouldFinish) return Option.of(key);
    }
    return const Option.none();
  }

  Option<String> _ctfWinnerId(GamePlayerState playerState) {
    final boardState = _boardRepository.state.value;
    final inventoryState = _inventoryRepository.state.value;
    return Option.Do(($) {
      final flagHolderId = $(_resolveFlagHolderId(inventoryState));
      final flagHolder = $(playerState.findById(flagHolderId));
      final cell = $(
        boardState.board.cellForPlayer(
          boardState.playerPositions,
          flagHolder.id,
        ),
      );
      if (!cell.isAtSpawn(flagHolder)) {
        return $(const Option.none());
      }
      return flagHolder.id;
    });
  }

  Option<String> _resolveFlagHolderId(GameInventoryState inventoryState) {
    return inventoryState.playerWithFlagId.match(
      () {
        for (final entry in inventoryState.itemsByPlayerId.entries) {
          final hasFlag = entry.value.any(
            (item) => item.type == ItemType.flag,
          );
          if (hasFlag) return Option.of(entry.key);
        }
        return const Option.none();
      },
      Option.of,
    );
  }

  void _finishGameIfWon() {
    _winnerId.value.whenPresent(
      (winnerId) => _actionsRepository.finishGame(
        FinishGameCommand(roomId: _roomId, winnerId: winnerId),
      ),
    );
  }
}

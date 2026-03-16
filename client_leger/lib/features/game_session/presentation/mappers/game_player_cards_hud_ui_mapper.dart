import 'package:fpdart/fpdart.dart';

import '../../core/constants/character_color_constants.dart';
import '../../../../core/enums/avatar.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../domain/state/game_inventory_state.dart';
import '../../domain/state/game_session_state.dart';
import '../../domain/state/game_player_state.dart';
import '../../domain/state/game_turn_state.dart';
import '../ui_models/components/game_player_ui_card.dart';

List<GamePlayerUiCard> toGamePlayerCardsHudCards(
  GamePlayerState playerState,
  GameTurnState turnState,
  GameSessionState sessionState,
  GameInventoryState inventoryState,
) {
  final hostId = sessionState.hostId;
  return playerState.players.map((p) {
    final avatar = Avatar.values.byName(p.characterType.name);
    final isActiveTurn = p.id == turnState.currentPlayerId;
    final hasFlag = inventoryState.playerWithFlagId.when(
      none: () => false,
      some: (flagHolderId) => p.id == flagHolderId,
    );
    final team = Option.of(p.team);
    return GamePlayerUiCard(
      id: p.id,
      name: p.name,
      avatar: avatar,
      color: CharacterColorConstants.hex(p.color),
      fightsWon: playerState.getWins(p.id),
      isActiveTurn: isActiveTurn,
      isHost: p.id == hostId,
      isDisconnected: playerState.disconnectedPlayerIds.contains(p.id),
      hasFlag: hasFlag,
      isVirtual: p.isVirtual,
      team: team,
    );
  }).toList();
}

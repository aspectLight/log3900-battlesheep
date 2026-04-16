import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/avatar_assets.dart';
import '../../../../core/constants/stat_assets.dart';
import '../../../../core/enums/avatar.dart';
import '../../core/enums/stat_type.dart';
import '../../domain/state/game_player_state.dart';
import '../ui_models/components/game_player_ui_stat.dart';
import '../ui_models/widget_states/game_player_hud_ui_state.dart';

Option<GamePlayerHudUiState> toGamePlayerHudUiState(
  GamePlayerState state,
  String currentPlayerId,
) {
  const statOrder = [
    StatType.health,
    StatType.attack,
    StatType.defense,
    StatType.speed,
  ];
  return state.findById(currentPlayerId).map((player) {
    final statRows = statOrder
        .map(
          (stat) => GamePlayerUiStat(
            statType: stat,
            value: player.statValue(stat),
            assetPath: StatAssets.statIconPath(stat),
          ),
        )
        .toList();
    final avatar = Avatar.values.byName(player.characterType.name);
    final avatarPath = AvatarAssets.avatarPath(avatar);
    final attackAsset = StatAssets.dicePath(StatType.attack, player.diceChoice);
    final defenseAsset = StatAssets.dicePath(
      StatType.defense,
      player.diceChoice,
    );
    return GamePlayerHudUiState(
      name: player.name,
      avatarPath: avatarPath,
      movementPoints: player.movementPoints,
      actionPoints: player.actionPoints,
      statRows: statRows,
      attackDiceAsset: attackAsset,
      defenseDiceAsset: defenseAsset,
    );
  });
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';

import '../../core/constants/game_rules_constants.dart';
import '../../core/constants/item_effect_constants.dart';
import '../../core/enums/board_character.dart';
import '../../core/enums/stat_type.dart';
import '../../../../core/enums/item_type.dart';
import '../models/game_board_position.dart';
import '../models/game_item.dart';
import '../events/game_events.dart';

part 'game_player_state.freezed.dart';

@freezed
class GamePlayer with _$GamePlayer {
  const factory GamePlayer({
    required String id,
    required String name,
    required BoardCharacterType characterType,
    required BoardCharacterColor color,
    required BoardCharacterOrientation orientation,
    required BoardCharacterState state,
    required int actionPoints,
    required int movementPoints,
    required Map<StatType, int> stats,
    required StatType diceChoice,
    required List<GameItem?> inventory,
    required bool isVirtual,
    required int team,
    required GameBoardPosition spawnPoint,
    @Default(false) bool propagandaActive,
  }) = _GamePlayer;

  const GamePlayer._();

  factory GamePlayer.fromSpawned(SpawnedPlayerEvent player) => GamePlayer(
    id: player.id,
    name: player.name,
    characterType: player.characterType,
    color: player.color,
    orientation: BoardCharacterOrientation.down,
    state: BoardCharacterState.idle,
    movementPoints: player.movementPoints,
    actionPoints: player.actionPoints,
    stats: player.stats,
    diceChoice: player.diceChoice,
    inventory: [
      if (player.inventory.isNotEmpty) player.inventory[0] else null,
      if (player.inventory.length >= GameRulesConstants.inventorySlotCount)
        player.inventory[GameRulesConstants.inventorySlotCount - 1]
      else
        null,
    ],
    isVirtual: player.isVirtual,
    team: player.team,
    spawnPoint: player.spawnPoint,
  );

  int statValue(StatType stat) => switch (stat) {
    StatType.health => stats[StatType.health]!,
    StatType.speed => stats[StatType.speed]!,
    StatType.attack => stats[StatType.attack]!,
    StatType.defense => stats[StatType.defense]!,
  };

  GamePlayer withItemCollected(GameItem item) {
    final newInventory = List<GameItem?>.from(inventory);
    final firstNull = newInventory.indexWhere((entry) => entry == null);
    if (firstNull >= 0) {
      newInventory[firstNull] = item;
    }

    final nextStats = Map<StatType, int>.from(stats);
    var nextPropagandaActive = propagandaActive;

    switch (item.type) {
      case ItemType.adrenaline:
        nextStats[StatType.health] =
            nextStats[StatType.health]! +
            ItemEffectConstants.adrenalineHealthBoost;
      case ItemType.vodka:
        nextStats[StatType.attack] =
            nextStats[StatType.attack]! + ItemEffectConstants.vodkaAttackBoost;
        nextStats[StatType.speed] =
            (nextStats[StatType.speed]! -
                    ItemEffectConstants.vodkaSpeedReduction)
                .clamp(0, 999);
      case ItemType.propaganda:
        final currentHealth = nextStats[StatType.health]!;
        if (currentHealth < ItemEffectConstants.propagandaHealthThreshold &&
            !propagandaActive) {
          nextStats[StatType.attack] =
              nextStats[StatType.attack]! +
              ItemEffectConstants.propagandaAttackBoost;
          nextStats[StatType.defense] =
              nextStats[StatType.defense]! +
              ItemEffectConstants.propagandaDefenseBoost;
          nextPropagandaActive = true;
        }
      case ItemType.barbedWire:
      case ItemType.camouflage:
      case ItemType.waterproofBoots:
      case ItemType.airStrike:
      case ItemType.torch:
      case ItemType.random:
      case ItemType.flag:
      case ItemType.spawnPoint:
        break;
    }

    return copyWith(
      inventory: newInventory,
      stats: nextStats,
      propagandaActive: nextPropagandaActive,
    );
  }

  GamePlayer withItemDropped(GameItem item) {
    final newInventory = List<GameItem?>.from(inventory);
    final idx = newInventory.indexWhere(
      (entry) => entry != null && entry.type == item.type,
    );
    if (idx >= 0) {
      newInventory[idx] = null;
    }

    final nextStats = Map<StatType, int>.from(stats);
    var nextPropagandaActive = propagandaActive;

    switch (item.type) {
      case ItemType.adrenaline:
        nextStats[StatType.health] =
            (nextStats[StatType.health]! -
                    ItemEffectConstants.adrenalineHealthBoost)
                .clamp(0, 999);
      case ItemType.vodka:
        nextStats[StatType.attack] =
            (nextStats[StatType.attack]! - ItemEffectConstants.vodkaAttackBoost)
                .clamp(0, 999);
        nextStats[StatType.speed] =
            nextStats[StatType.speed]! +
            ItemEffectConstants.vodkaSpeedReduction;
      case ItemType.propaganda:
        if (propagandaActive) {
          nextStats[StatType.attack] =
              (nextStats[StatType.attack]! -
                      ItemEffectConstants.propagandaAttackBoost)
                  .clamp(0, 999);
          nextStats[StatType.defense] =
              (nextStats[StatType.defense]! -
                      ItemEffectConstants.propagandaDefenseBoost)
                  .clamp(0, 999);
          nextPropagandaActive = false;
        }
      case ItemType.barbedWire:
      case ItemType.camouflage:
      case ItemType.waterproofBoots:
      case ItemType.airStrike:
      case ItemType.torch:
      case ItemType.random:
      case ItemType.flag:
      case ItemType.spawnPoint:
        break;
    }

    return copyWith(
      inventory: newInventory,
      stats: nextStats,
      propagandaActive: nextPropagandaActive,
    );
  }

  GamePlayer withDisconnectedDrop() {
    var updated = this;
    for (final item in inventory.whereType<GameItem>()) {
      updated = updated.withItemDropped(item);
    }
    return updated.copyWith(
      inventory: List<GameItem?>.filled(
        GameRulesConstants.inventorySlotCount,
        null,
      ),
      propagandaActive: false,
    );
  }

  GamePlayer withReevaluatedPropaganda() {
    final hasPropaganda = inventory.any(
      (entry) => entry?.type == ItemType.propaganda,
    );
    if (!hasPropaganda && !propagandaActive) {
      return this;
    }
    final health = stats[StatType.health]!;
    final below = health < ItemEffectConstants.propagandaHealthThreshold;

    if (below && !propagandaActive && hasPropaganda) {
      final next = Map<StatType, int>.from(stats)
        ..[StatType.attack] =
            stats[StatType.attack]! + ItemEffectConstants.propagandaAttackBoost
        ..[StatType.defense] =
            stats[StatType.defense]! +
            ItemEffectConstants.propagandaDefenseBoost;
      return copyWith(stats: next, propagandaActive: true);
    }

    if ((!below || !hasPropaganda) && propagandaActive) {
      final next = Map<StatType, int>.from(stats)
        ..[StatType.attack] =
            (stats[StatType.attack]! -
                    ItemEffectConstants.propagandaAttackBoost)
                .clamp(0, 999)
        ..[StatType.defense] =
            (stats[StatType.defense]! -
                    ItemEffectConstants.propagandaDefenseBoost)
                .clamp(0, 999);
      return copyWith(stats: next, propagandaActive: false);
    }

    return this;
  }
}

@freezed
class GamePlayerState with _$GamePlayerState {
  const factory GamePlayerState({
    required List<GamePlayer> players,
    required Option<String> activePlayerId,
    required List<String> disconnectedPlayerIds,
    required Map<String, int> winsByPlayerId,
  }) = _GamePlayerState;

  const GamePlayerState._();

  factory GamePlayerState.initial() => const GamePlayerState(
    players: [],
    activePlayerId: Option.none(),
    disconnectedPlayerIds: [],
    winsByPlayerId: {},
  );

  int getWins(String playerId) => winsByPlayerId[playerId] ?? 0;

  Option<GamePlayer> findById(String id) {
    for (final p in players) {
      if (p.id == id) return Option.of(p);
    }
    return const Option.none();
  }

  Option<GameBoardPosition> spawnPointOfAbandoned(String playerId) =>
      findById(playerId).map((p) => p.spawnPoint);

  int indexOf(String id) {
    for (var i = 0; i < players.length; i++) {
      if (players[i].id == id) return i;
    }
    return -1;
  }
}

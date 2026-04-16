import 'package:fpdart/fpdart.dart';

import '../../core/constants/game_rules_constants.dart';
import '../../../../core/enums/item_type.dart';
import '../../domain/models/game_item.dart';
import '../../domain/events/game_item_events.dart';
import '../../domain/state/game_inventory_state.dart';

class GameInventoryStateReducer {
  GameInventoryState reduce(GameInventoryState previous, Object event) {
    if (event is FlagCollectedEvent) {
      return _reduceFlagCollected(previous, event);
    }
    if (event is ItemDroppedEvent) {
      return _reduceItemDropped(previous, event);
    }
    if (event is ItemCollectedEvent) {
      return _reduceItemCollected(previous, event);
    }
    if (event is ItemDroppedDisconnectedEvent) {
      return _reduceItemDroppedDisconnected(previous, event);
    }
    if (event is PlayerInventorySetEvent) {
      return _reducePlayerInventorySet(previous, event);
    }
    return previous;
  }

  GameInventoryState _reduceFlagCollected(
    GameInventoryState previous,
    FlagCollectedEvent event,
  ) {
    return previous.copyWith(playerWithFlagId: Option.of(event.playerId));
  }

  GameInventoryState _reduceItemDropped(
    GameInventoryState previous,
    ItemDroppedEvent event,
  ) {
    final playerId = event.playerId;
    if (playerId == null) return previous;
    final current = previous.itemsByPlayerId[playerId] ?? [];
    final index = current.indexWhere((i) => i.type == event.item.type);
    if (index < 0) return previous;
    final nextList = List<GameItem>.from(current)..removeAt(index);
    final next = Map<String, List<GameItem>>.from(previous.itemsByPlayerId);
    next[playerId] = nextList;
    final clearFlag = event.item.type == ItemType.flag;
    return previous.copyWith(
      itemsByPlayerId: next,
      playerWithFlagId: clearFlag
          ? const Option.none()
          : previous.playerWithFlagId,
    );
  }

  GameInventoryState _reduceItemCollected(
    GameInventoryState previous,
    ItemCollectedEvent event,
  ) {
    if (event.inventoryFull) return previous;
    final current = previous.itemsByPlayerId[event.playerId] ?? [];
    if (current.length >= GameRulesConstants.inventorySlotCount)
      return previous;
    final next = Map<String, List<GameItem>>.from(previous.itemsByPlayerId);
    next[event.playerId] = [...current, event.item];
    return previous.copyWith(itemsByPlayerId: next);
  }

  GameInventoryState _reduceItemDroppedDisconnected(
    GameInventoryState previous,
    ItemDroppedDisconnectedEvent event,
  ) {
    final droppedItems = event.items;
    if (droppedItems.isEmpty) return previous;

    String? disconnectedPlayerId;
    for (final entry in previous.itemsByPlayerId.entries) {
      final playerItems = entry.value;
      if (_inventoryMatchesDroppedItems(playerItems, droppedItems)) {
        disconnectedPlayerId = entry.key;
        break;
      }
    }

    final next = Map<String, List<GameItem>>.from(previous.itemsByPlayerId);
    if (disconnectedPlayerId != null) {
      next.remove(disconnectedPlayerId);
    }

    final hasFlag = droppedItems.any((item) => item.type == ItemType.flag);
    return previous.copyWith(
      itemsByPlayerId: next,
      playerWithFlagId: hasFlag
          ? const Option.none()
          : previous.playerWithFlagId,
    );
  }

  bool _inventoryMatchesDroppedItems(
    List<GameItem> inventory,
    List<GameItem> droppedItems,
  ) {
    if (inventory.length != droppedItems.length) return false;
    final inventoryTypes = inventory.map((i) => i.type).toList()..sort();
    final droppedTypes = droppedItems.map((i) => i.type).toList()..sort();
    for (var i = 0; i < inventoryTypes.length; i++) {
      if (inventoryTypes[i] != droppedTypes[i]) return false;
    }
    return true;
  }

  GameInventoryState _reducePlayerInventorySet(
    GameInventoryState previous,
    PlayerInventorySetEvent event,
  ) {
    final next = Map<String, List<GameItem>>.from(previous.itemsByPlayerId);
    next[event.playerId] = List<GameItem>.from(event.items);
    return previous.copyWith(itemsByPlayerId: next);
  }
}

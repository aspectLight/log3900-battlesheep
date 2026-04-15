import 'package:fpdart/fpdart.dart';

import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../../core/notification/notification_coordinator.dart';
import '../../../../core/notification/notification_intent.dart';
import '../../domain/commands/game_item_commands.dart';
import '../../domain/models/game_item.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/repositories/game_item_repository.dart';
import '../../data/services/game_events_socket.dart';
import '../../domain/events/game_events.dart';

class GameTurnEndItemCleanupSideEffect with DisposableSideEffect {
  final String _roomId;
  final String _socketId;
  final GameEventsSocket _eventsSocket;
  final GameBoardRepository _boardRepository;
  final GameItemRepository _itemRepository;
  final NotificationCoordinator _notificationCoordinator;

  GameTurnEndItemCleanupSideEffect({
    required String roomId,
    required String socketId,
    required GameEventsSocket eventsSocket,
    required GameBoardRepository boardRepository,
    required GameItemRepository itemRepository,
    required NotificationCoordinator notificationCoordinator,
  }) : _roomId = roomId,
       _socketId = socketId,
       _eventsSocket = eventsSocket,
       _boardRepository = boardRepository,
       _itemRepository = itemRepository,
       _notificationCoordinator = notificationCoordinator {
    trackSubscription(_eventsSocket.turnStartingStream.listen(_onTurnStarting));
  }

  void _onTurnStarting(TurnStartingEvent event) {
    if (event.nextPlayerId == _socketId) {
      _completeNotifications();
      return;
    }
    final boardState = _boardRepository.state.value;
    final pending = boardState.pendingItemPickup.filter(
      (p) => p.playerId == _socketId,
    );
    pending.whenPresent(
      (p) => _itemRepository.dropItem(
        ItemDroppedCommand(
          roomId: _roomId,
          source: PlayerItemDropSource(playerId: p.playerId),
          item: p.item,
          coords: p.cellCoords,
        ),
      ),
    );
    _completeNotifications();
  }

  void _completeNotifications() {
    final entries = _notificationCoordinator.entries.value;
    final toComplete = entries
        .where((e) => e.intent is InventoryFullDiscardIntent)
        .toList();
    for (final entry in toComplete) {
      final intent = entry.intent as InventoryFullDiscardIntent;
      intent.onComplete(const Option.none());
      _notificationCoordinator.remove(entry.id);
    }
  }
}

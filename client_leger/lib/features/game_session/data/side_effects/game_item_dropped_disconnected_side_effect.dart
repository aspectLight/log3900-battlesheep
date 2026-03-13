import '../../core/event_bus/game_session_event_bus.dart';
import '../../domain/use_cases/get_two_nearest_empty_cells.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../domain/models/game_item.dart';
import '../../domain/commands/game_item_commands.dart';
import '../../domain/events/game_item_events.dart';
import '../repositories/game_board_repository.dart';
import '../repositories/game_item_repository.dart';

class GameItemDroppedDisconnectedSideEffect with DisposableSideEffect {
  final GameBoardRepository _boardRepository;
  final GameItemRepository _itemRepository;

  GameItemDroppedDisconnectedSideEffect({
    required GameSessionEventBus gameSessionEventBus,
    required GameBoardRepository boardRepository,
    required GameItemRepository itemRepository,
  }) : _boardRepository = boardRepository,
       _itemRepository = itemRepository {
    trackSubscription(
      gameSessionEventBus.on<GameItemDroppedDisconnected>().listen((event) {
        _handleItemDroppedDisconnected(event.event);
      }),
    );
  }

  void _handleItemDroppedDisconnected(ItemDroppedDisconnectedEvent event) {
    final boardState = _boardRepository.state.value;
    final board = boardState.board;
    final cells = getTwoNearestEmptyCells(board, event.coords, boardState);
    for (var i = 0; i < event.items.length; i++) {
      final coords = i < cells.length ? cells[i] : event.coords;
      _itemRepository.dropItem(
        ItemDroppedCommand(
          roomId: event.roomId,
          source: const DisconnectedItemDropSource(),
          item: event.items[i],
          coords: coords,
        ),
      );
    }
  }
}

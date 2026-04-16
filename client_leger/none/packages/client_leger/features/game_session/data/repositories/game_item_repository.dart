import '../../domain/commands/game_item_commands.dart';
import '../services/game_item_socket.dart';

class GameItemRepository {
  final GameItemSocket _itemSocket;

  GameItemRepository({required GameItemSocket itemSocket})
    : _itemSocket = itemSocket;

  void collectItem(ItemCollectedCommand command) {
    _itemSocket.itemCollected(command);
  }

  void dropItem(ItemDroppedCommand command) {
    _itemSocket.itemDropped(command);
  }
}

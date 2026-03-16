import '../../../../core/enums/game_mode.dart';
import 'game_board_position.dart';
import 'game_item.dart';
import '../state/game_board_state.dart';

class Game {
  final String id;
  final String name;
  final String description;
  final GameMode mode;
  final Board board;
  final Map<GameBoardPosition, GameItem> initialItems;
  final bool isVisible;
  final String modificationDate;

  const Game({
    required this.id,
    required this.name,
    required this.description,
    required this.mode,
    required this.board,
    required this.initialItems,
    required this.isVisible,
    required this.modificationDate,
  });

  bool get isCTF => mode == GameMode.captureTheFlag;
}

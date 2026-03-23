import '../../../../core/modal/modal_intent.dart';
import '../../domain/models/game_info_model.dart';

class SelectGameSessionGamePreviewModalIntent extends ModalIntent {
  const SelectGameSessionGamePreviewModalIntent({
    required this.description,
    required this.imagePath,
    required this.boardSize,
    required this.boardMatrix,
  });

  final String description;
  final String imagePath;
  final int boardSize;
  final List<List<GameBoardPreviewCell>> boardMatrix;
}

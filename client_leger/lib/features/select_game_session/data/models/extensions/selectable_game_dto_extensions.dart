import '../../../domain/models/game_info_model.dart';
import '../dto/game_summary_dto.dart';

extension GameSummaryDtoToModel on GameSummaryDto {
  GameModelInfo toModel() => GameModelInfo(
    id: id,
    name: name,
    description: description,
    mode: mode,
    boardSize: board.size,
    isVisible: isVisible,
    lastModified: modificationDate,
  );
}

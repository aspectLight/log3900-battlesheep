import '../../../domain/models/game_board_position.dart';
import '../dto/game_board_position_dto.dart';

extension GameBoardPositionDtoToEntity on GameBoardPositionDto {
  GameBoardPosition toEntity() => GameBoardPosition(x: x, y: y);
}

extension GameBoardPositionToDto on GameBoardPosition {
  GameBoardPositionDto toDto() => GameBoardPositionDto(x: x, y: y);
}

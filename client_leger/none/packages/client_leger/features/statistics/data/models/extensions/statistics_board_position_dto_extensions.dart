import '../../../domain/models/statistics_board_position.dart';
import '../dto/statistics_board_position_dto.dart';

extension StatisticsBoardPositionDtoToEntity on StatisticsBoardPositionDto {
  StatisticsBoardPosition toEntity() => StatisticsBoardPosition(x: x, y: y);
}

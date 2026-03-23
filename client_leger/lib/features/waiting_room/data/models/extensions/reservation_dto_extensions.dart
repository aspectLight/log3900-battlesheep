import '../../../domain/models/reservation_model.dart';
import '../dto/reservation_dto.dart';

extension ReservationDtoToModel on ReservationDto {
  ReservationModel toModel() =>
      ReservationModel(character: character, playerId: playerId);
}

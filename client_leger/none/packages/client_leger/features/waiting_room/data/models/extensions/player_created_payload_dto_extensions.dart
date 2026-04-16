import '../../../domain/models/waiting_room_player_model.dart';
import '../dto/player_created_payload_dto.dart';
import 'waiting_room_player_dto_extensions.dart';

extension PlayerCreatedPayloadDtoToModelList on PlayerCreatedPayloadDto {
  List<WaitingRoomPlayerModel> toModels() {
    return players.map((player) => player.toModel()).toList();
  }
}

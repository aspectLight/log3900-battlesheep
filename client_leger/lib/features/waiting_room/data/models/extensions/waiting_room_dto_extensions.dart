import '../../../domain/models/waiting_room_model.dart';
import '../dto/waiting_room_dto.dart';
import 'waiting_room_player_dto_extensions.dart';

extension WaitingRoomDtoToModel on WaitingRoomDto {
  WaitingRoomModel toModel() => WaitingRoomModel(
        roomId: roomId,
        hostId: hostId,
        players: players.map((p) => p.toModel()).toList(),
        isLocked: isLocked,
        dropInDropOut: dropInDropOut,
      );
}

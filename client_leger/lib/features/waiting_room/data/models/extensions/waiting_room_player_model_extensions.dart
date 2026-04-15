import '../../../domain/models/waiting_room_player_model.dart';
import '../dto/waiting_room_player_dto.dart';
import 'waiting_room_player_stats_dto_extensions.dart';

extension WaitingRoomPlayerModelToDto on WaitingRoomPlayerModel {
  WaitingRoomPlayerDto toDto() {
    return map(
      human: (p) => WaitingRoomPlayerDto(
        id: p.id,
        name: p.name,
        avatar: {'name': p.character.id},
        stats: p.stats.toDto(),
        activeBanner: p.activeBanner,
      ),
      virtual: (p) => WaitingRoomPlayerDto(
        id: p.id,
        name: p.name,
        avatar: {'name': p.character.id},
        stats: p.stats.toDto(),
        isVirtual: true,
        virtualType: p.virtualType,
        d6Choice: p.d6Choice,
        d4Choice: p.d4Choice,
        activeBanner: p.activeBanner,
      ),
    );
  }
}

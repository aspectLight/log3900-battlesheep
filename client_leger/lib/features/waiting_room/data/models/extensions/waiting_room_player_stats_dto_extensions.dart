import '../../../domain/models/waiting_room_player_stat_value_model.dart';
import '../../../domain/models/waiting_room_player_stats_model.dart';
import '../dto/waiting_room_player_stat_value_dto.dart';
import '../dto/waiting_room_player_stats_dto.dart';

extension WaitingRoomPlayerStatValueDtoToModel on WaitingRoomPlayerStatValueDto {
  WaitingRoomPlayerStatValueModel toModel() => WaitingRoomPlayerStatValueModel(
        value: value,
        maxValue: maxValue,
      );
}

extension WaitingRoomPlayerStatsDtoToModel on WaitingRoomPlayerStatsDto {
  WaitingRoomPlayerStatsModel toModel() => WaitingRoomPlayerStatsModel(
        health: health.toModel(),
        speed: speed.toModel(),
        attack: attack.toModel(),
        defense: defense.toModel(),
      );
}

extension WaitingRoomPlayerStatValueModelToDto on WaitingRoomPlayerStatValueModel {
  WaitingRoomPlayerStatValueDto toDto() => WaitingRoomPlayerStatValueDto(
        value: value,
        maxValue: maxValue,
        description: '',
      );
}

extension WaitingRoomPlayerStatsModelToDto on WaitingRoomPlayerStatsModel {
  WaitingRoomPlayerStatsDto toDto() => WaitingRoomPlayerStatsDto(
        health: health.toDto(),
        speed: speed.toDto(),
        attack: attack.toDto(),
        defense: defense.toDto(),
      );
}

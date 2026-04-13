import '../../../../../core/enums/character.dart';
import '../../../../../core/models/lobby_player_model.dart';
import '../../../../../core/models/lobby_room_model.dart';
import '../../../core/constants/waiting_room_stat_constants.dart';
import '../../../domain/models/waiting_room_model.dart';
import '../../../domain/models/waiting_room_player_model.dart';
import '../../../domain/models/waiting_room_player_stat_value_model.dart';
import '../../../domain/models/waiting_room_player_stats_model.dart';

extension LobbyRoomToWaitingRoomModel on LobbyRoomModel {
  WaitingRoomModel toWaitingRoomModel() => WaitingRoomModel(
    roomId: roomId,
    hostId: hostId,
    players: players.map((p) => p.toWaitingRoomPlayerModel()).toList(),
    isLocked: isLocked,
  );
}

extension LobbyPlayerToWaitingRoomPlayer on LobbyPlayerModel {
  WaitingRoomPlayerModel toWaitingRoomPlayerModel() {
    final character = Character.fromAvatarName(avatarName);
    final stats = toWaitingRoomPlayerStatsModel();
    if (isVirtual) {
      return WaitingRoomPlayerModel.virtual(
        id: id,
        name: name,
        character: character,
        stats: stats,
        virtualType: virtualType,
        activeBanner: activeBanner,
      );
    }
    return WaitingRoomPlayerModel.human(
      id: id,
      name: name,
      character: character,
      stats: stats,
      activeBanner: activeBanner,
    );
  }

  WaitingRoomPlayerStatsModel toWaitingRoomPlayerStatsModel() {
    WaitingRoomPlayerStatValueModel stat(int value) =>
        WaitingRoomPlayerStatValueModel(
          value: value,
          maxValue: WaitingRoomStatConstants.defaultWaitingRoomStatMaxValue,
        );
    return WaitingRoomPlayerStatsModel(
      health: stat(health),
      speed: stat(speed),
      attack: stat(attack),
      defense: stat(defense),
    );
  }
}

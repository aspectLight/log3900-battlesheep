import '../../../../../core/enums/virtual_player_type.dart';
import '../../../../../core/models/lobby_player_model.dart';
import '../../../../../core/models/lobby_room_model.dart';
import '../../../core/exceptions/join_game_session_failure.dart';
import '../dto/join_room_response_dto.dart';

extension JoinRoomResponseDtoFailureExtensions on JoinRoomResponseDto {
  JoinGameSessionFailure toFailure() {
    final normalized = error?.toLowerCase() ?? '';
    if (normalized.contains('existe pas')) {
      return const RoomNotFoundJoinGameSessionFailure();
    }
    if (normalized.contains('verrouill')) {
      return const RoomLockedJoinGameSessionFailure();
    }
    if (normalized.contains('nombre maximum de joueurs')) {
      return const MaxPlayerLimitReachedJoinGameSessionFailure();
    }
    if (normalized.contains('solde insuffisant')) {
      return const InsufficientBalanceJoinGameSessionFailure();
    }
    return UnknownJoinGameSessionFailure(error ?? 'Unknown error');
  }
}

extension JoinRoomDtoRoomExtensions on JoinRoomDto {
  LobbyRoomModel toLobbyRoomModel() => LobbyRoomModel(
    roomId: roomId,
    hostId: hostId,
    players: players.map((p) => p.toLobbyPlayerModel()).toList(),
    isLocked: isLocked,
    dropInDropOut: dropInDropOut,
    entryFee: entryFee,
    friendsOnly: friendsOnly,
  );
}

extension JoinRoomPlayerDtoLobbyExtensions on JoinRoomPlayerDto {
  LobbyPlayerModel toLobbyPlayerModel() => LobbyPlayerModel(
    id: id,
    name: name,
    avatarName: avatarName,
    isVirtual: isVirtual,
    virtualType: virtualType ?? VirtualPlayerType.aggressive,
    health: stats.health,
    speed: stats.speed,
    attack: stats.attack,
    defense: stats.defense,
    activeBanner: activeBanner,
  );
}

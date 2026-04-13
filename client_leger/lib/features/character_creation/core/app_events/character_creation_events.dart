import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/models/lobby_room_model.dart';

part 'character_creation_events.freezed.dart';

@freezed
sealed class CharacterCreationEntryAppEvent
    with _$CharacterCreationEntryAppEvent
    implements AppTransitionEvent {
  const factory CharacterCreationEntryAppEvent.hostEntered({
    required String socketId,
    required String roomCode,
    required String gameId,
    required String gameName,
    required String gameDescription,
    required int boardSize,
    required bool isCTF,
    @Default(0) int entryFee,
  }) = CharacterCreationHostEntered;
  const factory CharacterCreationEntryAppEvent.joinEntered({
    required String socketId,
    required String roomCode,
    required String hostId,
    required LobbyRoomModel initialRoom,
  }) = CharacterCreationJoinEntered;
}

@freezed
sealed class CharacterCreationCompletedAppEvent
    with _$CharacterCreationCompletedAppEvent
    implements AppTransitionEvent {
  const factory CharacterCreationCompletedAppEvent.ready() =
      CharacterCreationReady;
}

@freezed
sealed class CharacterCreationExitAppEvent
    with _$CharacterCreationExitAppEvent
    implements AppTransitionEvent {
  const factory CharacterCreationExitAppEvent.exitRequested() =
      CharacterCreationExitRequested;
  const factory CharacterCreationExitAppEvent.transitionToWaitingRoom({
    required String roomCode,
  }) = CharacterCreationTransitionToWaitingRoom;
}

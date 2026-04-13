import 'package:get_it/get_it.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/app_transition/auto_scope_coordinator.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../../waiting_room/core/app_events/waiting_room_events.dart';
import '../../domain/models/character_creation_entry_mode.dart';
import '../app_events/character_creation_events.dart';
import '../context/character_creation_data.dart';
import '../context/character_creation_scope_holder.dart';
import '../di/character_creation_module.dart';

class CharacterCreationCoordinator
    extends
        AutoScopeCoordinator<
          CharacterCreationData,
          CharacterCreationEntryAppEvent,
          CharacterCreationCompletedAppEvent,
          CharacterCreationExitAppEvent
        > {
  CharacterCreationCoordinator({
    required this.getIt,
    required this.appTransitionEventBus,
    required this.sessionScopeManager,
    required this.scopeHolder,
    required this.appNavigator,
  });

  final GetIt getIt;
  final AppTransitionEventBus appTransitionEventBus;
  @override
  final SessionScopeManager sessionScopeManager;
  final CharacterCreationScopeHolder scopeHolder;
  final AppNavigator appNavigator;

  @override
  final String scopeName = 'character_creation';

  @override
  void onScopeCreated(GetIt scope) {
    scopeHolder.setScope(scope);
  }

  @override
  void onScopeDropped() {
    scopeHolder.clearScope();
  }

  @override
  Future<CharacterCreationData?> onEntryImpl(
    CharacterCreationEntryAppEvent event,
  ) async {
    appTransitionEventBus.fire(
      const CharacterCreationCompletedAppEvent.ready(),
    );
    final (socketId, roomCode, entryMode) = switch (event) {
      CharacterCreationHostEntered(
        :final socketId,
        :final roomCode,
        :final gameId,
        :final gameName,
        :final gameDescription,
        :final boardSize,
        :final isCTF,
        :final entryFee,
        :final friendsOnly,
      ) => (
        socketId,
        roomCode,
        CharacterCreationHostEntryMode(
          gameId: gameId,
          gameName: gameName,
          gameDescription: gameDescription,
          boardSize: boardSize,
          isCTF: isCTF,
          entryFee: entryFee,
          friendsOnly: friendsOnly,
        ),
      ),
      CharacterCreationJoinEntered(
        :final socketId,
        :final roomCode,
        :final hostId,
        :final initialRoom,
        :final isDropIn,
      ) => (
        socketId,
        roomCode,
        CharacterCreationJoinEntryMode(
          hostId: hostId,
          initialRoom: initialRoom,
          isDropIn: isDropIn,
        ),
      ),
    };
    return CharacterCreationData(
      roomCode: roomCode,
      socketId: socketId,
      entryMode: entryMode,
    );
  }

  @override
  Future<void> onCompletedImpl(
    CharacterCreationCompletedAppEvent event,
    CharacterCreationData data,
  ) async {
    final scope = featureScope;
    if (scope == null) return;
    registerCharacterCreationScope(
      scope,
      getIt,
      roomCode: data.roomCode,
      socketId: data.socketId,
      entryMode: data.entryMode,
    );
    appNavigator.request(GoToCharacterCreation());
  }

  @override
  Future<void> onExitImpl(
    CharacterCreationExitAppEvent event,
    CharacterCreationData data,
  ) async {
    switch (event) {
      case CharacterCreationExitRequested():
        _onExitRequested(data);
      case CharacterCreationTransitionToWaitingRoom(:final roomCode):
        _onExitToWaitingRoom(roomCode, data);
    }
  }

  void _onExitRequested(CharacterCreationData data) {
    switch (data.entryMode) {
      case CharacterCreationHostEntryMode():
        appNavigator.request(GoToSelectGameSession());
      case CharacterCreationJoinEntryMode():
        appNavigator.request(ExitToMainMenu());
    }
  }

  void _onExitToWaitingRoom(String roomCode, CharacterCreationData data) {
    switch (data.entryMode) {
      case CharacterCreationHostEntryMode(
        :final boardSize,
        :final isCTF,
        :final gameName,
        :final gameDescription,
        :final friendsOnly,
      ):
        appTransitionEventBus.fire(
          WaitingRoomEntryAppEvent.enteredAsHost(
            roomId: roomCode,
            hostId: data.socketId,
            socketId: data.socketId,
            gameName: gameName,
            gameDescription: gameDescription,
            boardSize: boardSize,
            isCTF: isCTF,
            friendsOnly: friendsOnly,
          ),
        );
      case CharacterCreationJoinEntryMode(:final hostId, :final initialRoom):
        appTransitionEventBus.fire(
          WaitingRoomEntryAppEvent.enteredAsJoin(
            roomId: roomCode,
            hostId: hostId,
            socketId: data.socketId,
            gameName: '',
            gameDescription: '',
            initialRoom: initialRoom,
          ),
        );
    }
  }
}

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/app_transition/feature_coordinator.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../../character_creation/core/app_events/character_creation_events.dart';
import '../app_events/join_game_session_events.dart';

class JoinGameSessionCoordinator
    implements
        FeatureCoordinator<
          JoinGameSessionEntryAppEvent,
          JoinGameSessionCompletedAppEvent,
          JoinGameSessionExitAppEvent
        > {
  JoinGameSessionCoordinator({
    required this.appNavigator,
    required this.appTransitionEventBus,
  });

  final AppNavigator appNavigator;
  final AppTransitionEventBus appTransitionEventBus;

  @override
  Future<void> onEntry(JoinGameSessionEntryAppEvent event) async {
    appNavigator.request(GoToJoinGameSession());
  }

  @override
  Future<void> onCompleted(JoinGameSessionCompletedAppEvent event) async {}

  @override
  Future<void> onExit(JoinGameSessionExitAppEvent event) async {
    switch (event) {
      case JoinGameSessionLeaveRequested():
        appNavigator.request(ExitToMainMenu());
      case JoinGameSessionJoinSucceeded(:final result):
        appTransitionEventBus.fire(
          CharacterCreationEntryAppEvent.joinEntered(
            socketId: result.socketId,
            roomCode: result.roomCode,
            hostId: result.hostId,
            initialRoom: result.initialRoom,
            isDropIn: result.isDropIn,
          ),
        );
    }
  }
}

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/app_transition/feature_coordinator.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/enums/game_mode.dart';
import '../../../../routing/app_navigator.dart';
import '../../../../routing/navigation_command.dart';
import '../../../authentication/data/repositories/session_repository.dart';
import '../../../authentication/domain/state/session_state.dart';
import '../../../character_creation/core/app_events/character_creation_events.dart';
import '../app_events/select_game_session_events.dart';

class SelectGameSessionCoordinator
    implements
        FeatureCoordinator<
          SelectGameSessionEntryAppEvent,
          SelectGameSessionCompletedAppEvent,
          SelectGameSessionExitAppEvent
        > {
  SelectGameSessionCoordinator({
    required this.appNavigator,
    required this.appTransitionEventBus,
    required this.sessionScopeManager,
  });

  final AppNavigator appNavigator;
  final AppTransitionEventBus appTransitionEventBus;
  final SessionScopeManager sessionScopeManager;

  @override
  Future<void> onEntry(SelectGameSessionEntryAppEvent event) async {
    appNavigator.request(GoToSelectGameSession());
  }

  @override
  Future<void> onCompleted(SelectGameSessionCompletedAppEvent event) async {}

  @override
  Future<void> onExit(SelectGameSessionExitAppEvent event) async {
    switch (event) {
      case SelectGameSessionCancelled():
        appNavigator.request(ExitToMainMenu());
      case SelectGameSessionGameSelected(
        :final gameId,
        :final gameName,
        :final gameDescription,
        :final gameMode,
        :final boardSize,
        :final friendsOnly,
      ):
        final scope = sessionScopeManager.currentScope;
        if (scope == null) return;
        final sessionState = scope.get<SessionRepository>().state.value;
        if (sessionState is SessionConnected) {
          appTransitionEventBus.fire(
            CharacterCreationEntryAppEvent.hostEntered(
              socketId: sessionState.socketId,
              roomCode: gameId,
              gameId: gameId,
              gameName: gameName,
              gameDescription: gameDescription,
              boardSize: boardSize,
              isCTF: gameMode == GameMode.captureTheFlag,
              friendsOnly: friendsOnly,
            ),
          );
        }
    }
  }
}

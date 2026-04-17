import '../../../../features/authentication/core/app_events/auth_events.dart';
import '../../../../features/friends/core/app_transition/friends_events.dart';
import '../../../../features/game_history/core/app_events/game_history_events.dart';
import '../../../../features/join_game_session/core/app_events/join_game_session_events.dart';
import '../../../../features/logs_history/core/app_events/logs_history_events.dart';
import '../../../../features/profile/core/app_events/profile_events.dart';
import '../../../../features/select_game_session/core/app_events/select_game_session_events.dart';
import '../../../../features/shop/core/app_events/shop_events.dart';
import '../../../../features/tutorial/core/coordinators/tutorial_coordinator.dart';
import '../../../app_transition/app_transition_bus.dart';

class MainMenuViewModel {
  MainMenuViewModel({
    required AppTransitionEventBus appTransitionEventBus,
    required TutorialCoordinator tutorialCoordinator,
  }) : _appTransitionEventBus = appTransitionEventBus,
       _tutorialCoordinator = tutorialCoordinator;

  final AppTransitionEventBus _appTransitionEventBus;
  final TutorialCoordinator _tutorialCoordinator;

  void dispose() {}

  Future<void> signOut() async {
    _appTransitionEventBus.fire(const AuthExitAppEvent.signOut());
  }

  void joinGame() {
    _appTransitionEventBus.fire(
      const JoinGameSessionEntryAppEvent.joinGameSessionRequested(),
    );
  }

  void administerGames() {
    _appTransitionEventBus.fire(
      const SelectGameSessionEntryAppEvent.startSelection(),
    );
  }

  void administerFriends() {
    _appTransitionEventBus.fire(const FriendsEntryAppEvent.requested());
  }

  void openConnectionHistory() {
    _appTransitionEventBus.fire(const LogsHistoryEntryAppEvent.requested());
  }

  void openGameHistory() {
    _appTransitionEventBus.fire(const GameHistoryEntryAppEvent.requested());
  }

  void openProfile() {
    _appTransitionEventBus.fire(const ProfileEntryAppEvent.requested());
  }

  void openShop() {
    _appTransitionEventBus.fire(const ShopEntryAppEvent.requested());
  }

  Future<void> checkTutorialStatus() async {
    await _tutorialCoordinator.checkAndLaunchTutorial();
  }
}

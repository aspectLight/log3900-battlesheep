import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../features/authentication/core/app_events/auth_events.dart';
import '../../../../features/authentication/core/interfaces/auth_repository.dart';
import '../../../../features/authentication/domain/models/user.dart';
import '../../../../features/friends/core/app_transition/friends_events.dart';
import '../../../../features/friends/domain/interfaces/friends_repository.dart';
import '../../../../features/game_history/core/app_events/game_history_events.dart';
import '../../../../features/join_game_session/core/app_events/join_game_session_events.dart';
import '../../../../features/logs_history/core/app_events/logs_history_events.dart';
import '../../../../features/profile/core/app_events/profile_events.dart';
import '../../../../features/select_game_session/core/app_events/select_game_session_events.dart';
import '../../../../features/tutorial/core/coordinators/tutorial_coordinator.dart';
import '../../../app_transition/app_transition_bus.dart';
import '../../../helpers/functional_programming.dart';

class MainMenuViewModel {
  MainMenuViewModel({
    required AuthRepository authRepository,
    required AppTransitionEventBus appTransitionEventBus,
    required FriendsRepository friendsRepository,
    required TutorialCoordinator tutorialCoordinator,
  }) : _authRepository = authRepository,
       _appTransitionEventBus = appTransitionEventBus,
       _friendsRepository = friendsRepository,
       _tutorialCoordinator = tutorialCoordinator {
    _authSub = _authRepository.authStateChanges.listen((userOption) {
      _currentUser.value = userOption;
    });
  }

  final AuthRepository _authRepository;
  final AppTransitionEventBus _appTransitionEventBus;
  final FriendsRepository _friendsRepository;
  final TutorialCoordinator _tutorialCoordinator;
  final pendingRequestCount = signal<int>(0);
  StreamSubscription<Option<UserModel>>? _authSub;

  final _currentUser = signal<Option<UserModel>>(const Option.none());

  late final username = computed(
    () => _currentUser.value.map((user) => user.username).orElse(''),
  );

  void dispose() {
    unawaited(_authSub?.cancel());
  }

  Future<void> signOut() async {
    _appTransitionEventBus.fire(const AuthExitAppEvent.signOut());
  }

  Future<void> loadPendingRequests() async {
    final requests = await _friendsRepository.loadPendingRequests();
    pendingRequestCount.value = requests.length;
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

  Future<void> checkTutorialStatus() async {
    await _tutorialCoordinator.checkAndLaunchTutorial();
  }
}

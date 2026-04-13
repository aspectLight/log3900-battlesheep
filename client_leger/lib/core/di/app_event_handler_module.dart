import 'package:get_it/get_it.dart';

import '../../features/authentication/core/app_events/auth_events.dart';
import '../../features/authentication/core/coordinators/authentication_coordinator.dart';
import '../../features/chat/core/app_events/chat_events.dart';
import '../../features/chat/core/coordinators/chat_coordinator.dart';
import '../../features/game_session/core/app_events/game_session_events.dart';
import '../../features/game_session/core/coordinators/game_session_coordinator.dart';
import '../../features/character_creation/core/app_events/character_creation_events.dart';
import '../../features/character_creation/core/coordinators/character_creation_coordinator.dart';
import '../../features/join_game_session/core/app_events/join_game_session_events.dart';
import '../../features/join_game_session/core/coordinators/join_game_session_coordinator.dart';
import '../../features/game_history/core/app_events/game_history_events.dart';
import '../../features/game_history/core/coordinators/game_history_coordinator.dart';
import '../../features/logs_history/core/app_events/logs_history_events.dart';
import '../../features/logs_history/core/coordinators/logs_history_coordinator.dart';
import '../../features/statistics/core/app_events/statistics_events.dart';
import '../../features/statistics/core/coordinators/statistics_coordinator.dart';
import '../../features/select_game_session/core/app_events/select_game_session_events.dart';
import '../../features/select_game_session/core/coordinators/select_game_session_coordinator.dart';
import '../../features/profile/core/app_events/profile_events.dart';
import '../../features/profile/core/coordinators/profile_coordinator.dart';
import '../../features/shop/core/app_events/shop_events.dart';
import '../../features/shop/core/coordinators/shop_coordinator.dart';
import '../../features/waiting_room/core/app_events/waiting_room_events.dart';
import '../../features/waiting_room/core/coordinators/waiting_room_coordinator.dart';
import '../app_transition/app_event_handler.dart';
import '../app_transition/app_transition_bus.dart';
import '../app_transition/generic_handler_delegate.dart';

void registerAppEventHandler(GetIt getIt) {
  getIt.registerLazySingleton<AppEventHandler>(
    () => _buildHandler(
      bus: getIt<AppTransitionEventBus>(),
      auth: getIt<AuthenticationCoordinator>(),
      chat: getIt<ChatCoordinator>(),
      game: getIt<GameSessionCoordinator>(),
      statistics: getIt<StatisticsCoordinator>(),
      joinGameSession: getIt<JoinGameSessionCoordinator>(),
      logsHistory: getIt<LogsHistoryCoordinator>(),
      gameHistory: getIt<GameHistoryCoordinator>(),
      selectGameSession: getIt<SelectGameSessionCoordinator>(),
      characterCreation: getIt<CharacterCreationCoordinator>(),
      waitingRoom: getIt<WaitingRoomCoordinator>(),
      profile: getIt<ProfileCoordinator>(),
      shop: getIt<ShopCoordinator>(),
    ),
  );
}

Future<void> _onAuthCompletedBootstrapChat(
  AuthCompletedAppEvent event,
  ChatCoordinator chatCoordinator,
) async {
  await chatCoordinator.onEntry(
    ChatEntryAppEvent.authCompleted(username: event.username),
  );
  await chatCoordinator.onCompleted(const ChatCompletedAppEvent());
}

AppEventHandler _buildHandler({
  required AppTransitionEventBus bus,
  required AuthenticationCoordinator auth,
  required ChatCoordinator chat,
  required GameSessionCoordinator game,
  required StatisticsCoordinator statistics,
  required JoinGameSessionCoordinator joinGameSession,
  required LogsHistoryCoordinator logsHistory,
  required GameHistoryCoordinator gameHistory,
  required SelectGameSessionCoordinator selectGameSession,
  required CharacterCreationCoordinator characterCreation,
  required WaitingRoomCoordinator waitingRoom,
  required ProfileCoordinator profile,
  required ShopCoordinator shop,
}) {
  return AppEventHandler(
    appTransitionEventBus: bus,
    delegates: [
      // --- Auth ---
      GenericHandlerDelegate<AuthEntryAppEvent>.simple(
        AuthEntryAppEvent,
        auth.onEntry,
      ),
      GenericHandlerDelegate<AuthCompletedAppEvent>.simple(
        AuthCompletedAppEvent,
        auth.onCompleted,
      ),
      GenericHandlerDelegate<AuthCompletedAppEvent>.simple(
        AuthCompletedAppEvent,
        (e) => _onAuthCompletedBootstrapChat(e, chat),
      ),
      GenericHandlerDelegate<AuthExitAppEvent>.simple(
        AuthExitAppEvent,
        (_) => chat.onExit(const ChatExitAppEvent.closed()),
      ),
      GenericHandlerDelegate<AuthExitAppEvent>.simple(
        AuthExitAppEvent,
        auth.onExit,
      ),
      // --- Game Session ---
      GenericHandlerDelegate<GameSessionEntryAppEvent>.simple(
        GameSessionEntryAppEvent,
        game.onEntry,
      ),
      GenericHandlerDelegate<GameSessionCompletedAppEvent>.simple(
        GameSessionCompletedAppEvent,
        game.onCompleted,
      ),
      GenericHandlerDelegate<GameSessionExitAppEvent>.simple(
        GameSessionExitAppEvent,
        game.onExit,
      ),
      // --- Statistics ---
      GenericHandlerDelegate<StatisticsEntryAppEvent>.simple(
        StatisticsEntryAppEvent,
        statistics.onEntry,
      ),
      GenericHandlerDelegate<StatisticsCompletedAppEvent>.simple(
        StatisticsCompletedAppEvent,
        statistics.onCompleted,
      ),
      GenericHandlerDelegate<StatisticsExitAppEvent>.simple(
        StatisticsExitAppEvent,
        statistics.onExit,
      ),
      // --- Join Game Session ---
      GenericHandlerDelegate<JoinGameSessionEntryAppEvent>.simple(
        JoinGameSessionEntryAppEvent,
        joinGameSession.onEntry,
      ),
      GenericHandlerDelegate<JoinGameSessionCompletedAppEvent>.simple(
        JoinGameSessionCompletedAppEvent,
        joinGameSession.onCompleted,
      ),
      GenericHandlerDelegate<JoinGameSessionExitAppEvent>.simple(
        JoinGameSessionExitAppEvent,
        joinGameSession.onExit,
      ),
      // --- Logs History ---
      GenericHandlerDelegate<LogsHistoryEntryAppEvent>.simple(
        LogsHistoryEntryAppEvent,
        logsHistory.onEntry,
      ),
      GenericHandlerDelegate<LogsHistoryCompletedAppEvent>.simple(
        LogsHistoryCompletedAppEvent,
        logsHistory.onCompleted,
      ),
      GenericHandlerDelegate<LogsHistoryExitAppEvent>.simple(
        LogsHistoryExitAppEvent,
        logsHistory.onExit,
      ),
      // --- Game History ---
      GenericHandlerDelegate<GameHistoryEntryAppEvent>.simple(
        GameHistoryEntryAppEvent,
        gameHistory.onEntry,
      ),
      GenericHandlerDelegate<GameHistoryCompletedAppEvent>.simple(
        GameHistoryCompletedAppEvent,
        gameHistory.onCompleted,
      ),
      GenericHandlerDelegate<GameHistoryExitAppEvent>.simple(
        GameHistoryExitAppEvent,
        gameHistory.onExit,
      ),
      // --- Select Game Session ---
      GenericHandlerDelegate<SelectGameSessionEntryAppEvent>.simple(
        SelectGameSessionEntryAppEvent,
        selectGameSession.onEntry,
      ),
      GenericHandlerDelegate<SelectGameSessionCompletedAppEvent>.simple(
        SelectGameSessionCompletedAppEvent,
        selectGameSession.onCompleted,
      ),
      GenericHandlerDelegate<SelectGameSessionExitAppEvent>.simple(
        SelectGameSessionExitAppEvent,
        selectGameSession.onExit,
      ),
      // --- Character Creation ---
      GenericHandlerDelegate<CharacterCreationEntryAppEvent>.simple(
        CharacterCreationEntryAppEvent,
        characterCreation.onEntry,
      ),
      GenericHandlerDelegate<CharacterCreationCompletedAppEvent>.simple(
        CharacterCreationCompletedAppEvent,
        characterCreation.onCompleted,
      ),
      GenericHandlerDelegate<CharacterCreationExitAppEvent>.simple(
        CharacterCreationExitAppEvent,
        characterCreation.onExit,
      ),
      // --- Waiting Room ---
      GenericHandlerDelegate<WaitingRoomEntryAppEvent>.simple(
        WaitingRoomEntryAppEvent,
        waitingRoom.onEntry,
      ),
      GenericHandlerDelegate<WaitingRoomCompletedAppEvent>.simple(
        WaitingRoomCompletedAppEvent,
        waitingRoom.onCompleted,
      ),
      GenericHandlerDelegate<WaitingRoomExitAppEvent>.simple(
        WaitingRoomExitAppEvent,
        waitingRoom.onExit,
      ),
      // --- Profile ---
      GenericHandlerDelegate<ProfileEntryAppEvent>.simple(
        ProfileEntryAppEvent,
        profile.onEntry,
      ),
      GenericHandlerDelegate<ProfileCompletedAppEvent>.simple(
        ProfileCompletedAppEvent,
        profile.onCompleted,
      ),
      GenericHandlerDelegate<ProfileExitAppEvent>.simple(
        ProfileExitAppEvent,
        profile.onExit,
      ),
      GenericHandlerDelegate<ShopEntryAppEvent>.simple(
        ShopEntryAppEvent,
        shop.onEntry,
      ),
      GenericHandlerDelegate<ShopCompletedAppEvent>.simple(
        ShopCompletedAppEvent,
        shop.onCompleted,
      ),
      GenericHandlerDelegate<ShopExitAppEvent>.simple(
        ShopExitAppEvent,
        shop.onExit,
      ),
    ],
  );
}

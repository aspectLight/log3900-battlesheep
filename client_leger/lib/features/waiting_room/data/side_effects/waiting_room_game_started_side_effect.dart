import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/connected_scope/session_scope_manager.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../../game_session/core/app_events/game_session_events.dart';
import '../../core/context/waiting_room_entry_data.dart';
import '../models/dto/game_room_created_payload_dto.dart';
import '../services/waiting_room_socket.dart';

class WaitingRoomGameStartedSideEffect with DisposableSideEffect {
  WaitingRoomGameStartedSideEffect({
    required WaitingRoomSocket waitingRoomSocket,
    required AppTransitionEventBus appTransitionEventBus,
    required SessionScopeManager sessionScopeManager,
    required WaitingRoomEntryData entryData,
  })  : _waitingRoomSocket = waitingRoomSocket,
        _appTransitionEventBus = appTransitionEventBus,
        _sessionScopeManager = sessionScopeManager,
        _entryData = entryData {
    trackSubscription(
      _waitingRoomSocket.gameRoomCreatedStream.listen(_onGameRoomCreated),
    );
  }

  final WaitingRoomSocket _waitingRoomSocket;
  final AppTransitionEventBus _appTransitionEventBus;
  final SessionScopeManager _sessionScopeManager;
  final WaitingRoomEntryData _entryData;

  void _onGameRoomCreated(GameRoomCreatedPayloadDto payload) {
    final socketId = _sessionScopeManager.currentSession?.socketId;
    if (socketId == null) return;
    final isHost = payload.hostId == socketId;
    final (gameName, gameDescription) = switch (_entryData) {
      WaitingRoomHostEntryData(:final gameName, :final gameDescription) => (
        gameName,
        gameDescription,
      ),
      WaitingRoomJoinEntryData(:final gameName, :final gameDescription) => (
        gameName,
        gameDescription,
      ),
    };
    _appTransitionEventBus.fire(
      GameSessionEntryAppEvent.startConfirmed(
        roomId: payload.roomId,
        gameId: payload.gameId,
        socketId: socketId,
        isHost: isHost,
        gameName: gameName,
        gameDescription: gameDescription,
      ),
    );
  }
}

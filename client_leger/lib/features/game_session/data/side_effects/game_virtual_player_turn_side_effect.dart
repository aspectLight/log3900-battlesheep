import 'package:fpdart/fpdart.dart';

import '../../domain/events/game_events.dart';
import '../../domain/state/game_session_state.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../domain/commands/game_action_commands.dart';
import '../../data/repositories/game_actions_repository.dart';
import '../../data/repositories/game_metadata_repository.dart';
import '../../data/repositories/game_player_repository.dart';
import '../../data/services/game_events_socket.dart';

class GameVirtualPlayerTurnSideEffect with DisposableSideEffect {
  final String _roomId;
  final String _socketId;
  final GamePlayerRepository _playerRepository;
  final GameMetadataRepository _metadataRepository;
  final GameActionsRepository _actionsRepository;
  final GameEventsSocket _eventsSocket;

  GameVirtualPlayerTurnSideEffect({
    required String roomId,
    required String socketId,
    required GameEventsSocket eventsSocket,
    required GamePlayerRepository playerRepository,
    required GameMetadataRepository metadataRepository,
    required GameActionsRepository actionsRepository,
  }) : _roomId = roomId,
       _socketId = socketId,
       _playerRepository = playerRepository,
       _metadataRepository = metadataRepository,
       _actionsRepository = actionsRepository,
       _eventsSocket = eventsSocket {
    trackSubscription(
      _eventsSocket.turnStartingStream.listen(_onTurnStarting),
    );
  }

  void _onTurnStarting(TurnStartingEvent event) {
    if (event.nextPlayerId == _socketId) return;
    final metadata = _metadataRepository.state.value;
    if (metadata is! GameSessionActive) return;
    if (_socketId != metadata.hostId) return;
    if (!event.isNextPlayerVirtual) {
      return;
    }
    final playerId = _playerRepository.state.value
        .findById(event.nextPlayerId)
        .map((p) => p.id)
        .getOrElse(() => event.nextPlayerId);
    _actionsRepository.runVirtualPlayerTurn(
      VirtualPlayerTurnCommand(
        roomId: _roomId,
        playerId: playerId,
        isCTF: metadata.isCTF,
        skipTimeout: false,
      ),
    );
  }
}

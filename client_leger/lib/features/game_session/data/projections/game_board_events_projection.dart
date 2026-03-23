import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../data/repositories/game_board_repository.dart';
import '../../data/services/game_board_socket.dart';
import '../../domain/events/game_events.dart';

class GameBoardEventsProjection implements EventProjection {
  final GameBoardSocket _boardSocket;
  final GameBoardRepository _boardRepository;
  final GameSessionEventBus _gameSessionEventBus;

  GameBoardEventsProjection({
    required GameBoardSocket boardSocket,
    required GameBoardRepository boardRepository,
    required GameSessionEventBus gameSessionEventBus,
  }) : _boardSocket = boardSocket,
       _boardRepository = boardRepository,
       _gameSessionEventBus = gameSessionEventBus;

  @override
  List<StreamSubscription> subscribe() => [
    _boardSocket.doorToggledStream.listen(_onDoorToggled),
  ];

  void _onDoorToggled(DoorToggledEvent event) {
    _boardRepository.applyDoorToggled(event);
    _gameSessionEventBus.fire(event);
  }
}

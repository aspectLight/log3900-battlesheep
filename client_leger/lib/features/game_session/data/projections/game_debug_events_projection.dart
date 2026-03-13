import 'dart:async';

import '../../../../core/interfaces/event_projection.dart';
import '../../core/event_bus/game_session_event_bus.dart';
import '../../data/repositories/game_debug_repository.dart';
import '../../data/services/game_debug_socket.dart';
import '../../domain/events/game_debug_events.dart';

class GameDebugEventsProjection implements EventProjection {
  final GameDebugSocket _debugSocket;
  final GameDebugRepository _debugRepository;
  final GameSessionEventBus _gameSessionEventBus;

  GameDebugEventsProjection({
    required GameDebugSocket debugSocket,
    required GameDebugRepository debugRepository,
    required GameSessionEventBus gameSessionEventBus,
  }) : _debugSocket = debugSocket,
       _debugRepository = debugRepository,
       _gameSessionEventBus = gameSessionEventBus;

  @override
  List<StreamSubscription> subscribe() => [
    _debugSocket.debugModeEnabledStream.listen(_onDebugModeEnabled),
    _debugSocket.debugModeDisabledStream.listen(_onDebugModeDisabled),
  ];

  void _onDebugModeEnabled(DebugModeEnabledEvent event) {
    _debugRepository.applyDebugModeEnabled(event);
    _gameSessionEventBus.fire(event);
  }

  void _onDebugModeDisabled(DebugModeDisabledEvent event) {
    _debugRepository.applyDebugModeDisabled(event);
    _gameSessionEventBus.fire(event);
  }
}

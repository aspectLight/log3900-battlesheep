import 'package:signals_flutter/signals_flutter.dart';

import '../services/game_debug_socket.dart';
import '../../domain/events/game_debug_events.dart';
import '../../domain/commands/game_debug_commands.dart';
import '../../domain/state/game_debug_state.dart';

class GameDebugRepository {
  final GameDebugSocket _debugSocket;

  final Signal<GameDebugState> state = signal(GameDebugState.initial());

  GameDebugRepository({required GameDebugSocket debugSocket})
    : _debugSocket = debugSocket;

  void toggleDebugMode(ToggleDebugModeCommand command) {
    _debugSocket.toggleDebugMode(command);
  }

  void applyDebugModeEnabled(DebugModeEnabledEvent event) {
    state.value = state.value.copyWith(isDebugMode: true);
  }

  void applyDebugModeDisabled(DebugModeDisabledEvent event) {
    state.value = state.value.copyWith(isDebugMode: false);
  }

}

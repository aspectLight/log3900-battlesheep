import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/events/game_events.dart';
import '../../domain/state/game_session_state.dart';
import '../reducers/game_metadata_state_reducer.dart';

class GameMetadataRepository {
  final GameMetadataStateReducer _reducer;

  final Signal<GameSessionState> state;

  GameMetadataRepository({
    required GameMetadataStateReducer reducer,
    required String roomId,
    bool isCTF = false,
    String initialHostId = '',
  })  : _reducer = reducer,
        state = signal(
          GameSessionActive(
            roomId: roomId,
            hostId: initialHostId,
            isCTF: isCTF,
          ),
        );

  void applyFinishGame(FinishGameEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }

  void applyOrganizatorChanged(OrganizatorChangedEvent event) {
    state.value = _reducer.reduce(state.value, event);
  }
}

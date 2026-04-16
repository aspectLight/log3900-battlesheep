import '../../domain/events/game_events.dart';
import '../../domain/state/game_session_state.dart';

class GameMetadataStateReducer {
  GameSessionState reduce(GameSessionState previous, Object event) {
    if (event is FinishGameEvent) {
      return _reduceFinishGame(previous, event);
    }
    if (event is OrganizatorChangedEvent) {
      return _reduceOrganizatorChanged(previous, event);
    }
    return previous;
  }

  GameSessionState _reduceFinishGame(
    GameSessionState previous,
    FinishGameEvent event,
  ) {
    return previous.map(
      active: (s) => GameSessionState.finished(
        roomId: s.roomId,
        winnerId: event.winnerId,
        hostId: s.hostId,
        isCTF: s.isCTF,
      ),
      finished: (s) => s.copyWith(winnerId: event.winnerId),
    );
  }

  GameSessionState _reduceOrganizatorChanged(
    GameSessionState previous,
    OrganizatorChangedEvent event,
  ) {
    return previous.map(
      active: (s) => s.copyWith(hostId: event.newHostId),
      finished: (s) => s.copyWith(hostId: event.newHostId),
    );
  }
}

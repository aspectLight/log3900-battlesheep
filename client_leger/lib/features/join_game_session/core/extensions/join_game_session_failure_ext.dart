import '../localisation/join_game_session_localizations.dart';
import '../exceptions/join_game_session_failure.dart';

extension JoinGameSessionFailureExt on JoinGameSessionFailure {
  String localize(JoinGameSessionLocalizations l10n) {
    if (this is RoomNotFoundJoinGameSessionFailure) {
      return l10n.waitingRoomRoomNotFound;
    }
    if (this is RoomLockedJoinGameSessionFailure) {
      return l10n.waitingRoomRoomLocked;
    }
    if (this is MaxPlayerLimitReachedJoinGameSessionFailure) {
      return l10n.joinGameMaxPlayerLimitReached;
    }
    return l10n.joinGameFailed;
  }
}

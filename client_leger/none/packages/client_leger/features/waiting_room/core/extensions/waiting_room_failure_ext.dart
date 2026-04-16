import '../localisation/waiting_room_localizations.dart';
import '../exceptions/waiting_room_failure.dart';

extension WaitingRoomFailureExt on WaitingRoomFailure {
  String localize(WaitingRoomLocalizations l10n) {
    if (this is RoomNotFoundWaitingRoomFailure) {
      return l10n.waitingRoomRoomNotFound;
    }
    if (this is RoomLockedWaitingRoomFailure) {
      return l10n.waitingRoomRoomLocked;
    }
    if (this is CharacterAlreadyReservedWaitingRoomFailure) {
      return l10n.waitingRoomCharacterAlreadyReserved;
    }
    if (this is PlayerAlreadyInRoomWaitingRoomFailure) {
      return l10n.waitingRoomPlayerAlreadyInRoom;
    }
    if (this is PlayerKickedWaitingRoomFailure) {
      return l10n.waitingRoomPlayerKicked;
    }
    if (this is MaxPlayerLimitReachedWaitingRoomFailure) {
      return l10n.waitingRoomMaxPlayerLimitReached;
    }
    if (this is StartGameFailedWaitingRoomFailure) {
      return l10n.waitingRoomStartGameFailed;
    }
    return l10n.unknownError;
  }
}

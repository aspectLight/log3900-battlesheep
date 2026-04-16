class WaitingRoomSocketEventsOutbound {
  const WaitingRoomSocketEventsOutbound();

  String get createWaitingRoom => 'createWaitingRoom';
  String get joinWaitingRoom => 'joinWaitingRoom';
  String get leaveWaitingRoom => 'leaveWaitingRoom';
  String get toggleLockWaitingRoom => 'toggleLockWaitingRoom';
  String get toggleDropInDropOut => 'toggleDropInDropOut';
  String get kickPlayer => 'kickPlayer';
  String get createPlayer => 'createPlayer';
  String get startGame => 'startGame';
  String get reserveAvatar => 'reserveAvatar';
  String get getReservedAvatars => 'getReservedAvatars';
  String get playGame => 'playGame';
}

class WaitingRoomSocketEventsInbound {
  const WaitingRoomSocketEventsInbound();

  String get waitingRoomCreated => 'waitingRoomCreated';
  String get joinRoomResponse => 'joinRoomResponse';
  String get leaveRoomResponse => 'leaveRoomResponse';
  String get roomCanceled => 'roomCanceled';
  String get waitingRoomLocked => 'waitingRoomLocked';
  String get waitingRoomUnlocked => 'waitingRoomUnlocked';
  String get dropInDropOutToggled => 'dropInDropOutToggled';
  String get playerLeft => 'playerLeft';
  String get playerCreated => 'playerCreated';
  String get playerKicked => 'playerKicked';
  String get updateAvatarReserved => 'updateAvatarReserved';
  String get waitingRoomError => 'waitingRoomError';
  String get gameRoomCreated => 'gameRoomCreated';
}

abstract final class WaitingRoomSocketEvents {
  const WaitingRoomSocketEvents._();

  static const WaitingRoomSocketEventsOutbound outbound =
      WaitingRoomSocketEventsOutbound();
  static const WaitingRoomSocketEventsInbound inbound =
      WaitingRoomSocketEventsInbound();
}

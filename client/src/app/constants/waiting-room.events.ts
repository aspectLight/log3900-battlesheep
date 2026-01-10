export enum WaitingRoomEvents {
    CreateWaitingRoom = 'createWaitingRoom',
    WaitingRoomCreated = 'waitingRoomCreated',
    ToggleLockWaitingRoom = 'toggleLockWaitingRoom',
    WaitingRoomLocked = 'waitingRoomLocked',
    WaitingRoomUnlocked = 'waitingRoomUnlocked',

    JoinWaitingRoom = 'joinWaitingRoom',
    PlayerJoined = 'playerJoined',
    LeaveRoom = 'leaveRoom',
    PlayerLeft = 'playerLeft',
    KickPlayer = 'kickPlayer',
    PlayerKicked = 'playerKicked',

    StartGame = 'startGame',
    GameStarted = 'gameStarted',
    CancelRoom = 'cancelRoom',
    RoomCanceled = 'roomCanceled',

    WaitingRoomError = 'waitingRoomError',
}

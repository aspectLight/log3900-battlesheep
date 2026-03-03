export enum WaitingRoomEvents {
    GenerateCode = 'generateCode',
    GenerateCodeResponse = 'generateCodeResponse',
    CreateWaitingRoom = 'createWaitingRoom',
    WaitingRoomCreated = 'waitingRoomCreated',
    ToggleLockWaitingRoom = 'toggleLockWaitingRoom',
    WaitingRoomLocked = 'waitingRoomLocked',
    WaitingRoomUnlocked = 'waitingRoomUnlocked',

    CheckRoomExists = 'checkRoomExists',
    RoomExistsResponse = 'roomExistsResponse',
    GetReservedAvatars = 'getReservedAvatars',
    UpdateAvatarReserved = 'updateAvatarReserved',
    ReserveAvatar = 'reserveAvatar',
    JoinWaitingRoom = 'joinWaitingRoom',
    JoinRoomResponse = 'joinRoomResponse',
    CreatePlayer = 'createPlayer',
    PlayerCreated = 'playerCreated',
    LeaveRoomResponse = 'leaveRoomResponse',
    PlayerLeft = 'playerLeft',
    KickPlayer = 'kickPlayer',
    PlayerKicked = 'playerKicked',
    LeaveWaitingRoom = 'leaveWaitingRoom',

    StartGame = 'startGame',
    CancelRoom = 'cancelRoom',
    RoomCanceled = 'roomCanceled',

    SendMessageToWaitingRoom = 'sendMessageToWaitingRoom',
    MassMessage = 'massMessage',
    GetMessagesFromWaitingRoom = 'getMessagesFromWaitingRoom',
    GetMessagesResponse = 'getMessagesResponse',

    WaitingRoomError = 'waitingRoomError',

    GetAvailableRooms = 'getAvailableRooms',
    AvailableRoomsResponse = 'availableRoomsResponse',

    ToggleDropInDropOut = 'toggleDropInDropOut',
    DropInDropOutToggled = 'dropInDropOutToggled',
}

export enum GameRoomEvents {
    CreateGameRoom = 'createGameRoom',
    GameRoomCreated = 'gameRoomCreated',

    AbandonGame = 'abandonGame',
    PlayerAbandoned = 'playerAbandoned',
    QuitEndGame = 'quitEndGame',
    GameCanceled = 'gameCanceled',
    GameAbandoned = 'gameAbandoned',
    LeaveGameRoom = 'leaveGameRoom',
    PlayerLeft = 'playerLeft',
    GameRoomCanceled = 'GameRoomCanceled',

    PlayerGetMovements = 'playerGetMovements',
    PlayerSpawned = 'playerSpawned',
    PlayerMovements = 'playerMovements',
    PlayerMoved = 'playerMoved',
    ItemCollected = 'itemCollected',
    ItemDropped = 'itemDropped',
    ItemDroppedDisconnected = 'itemDroppedDisconnected',
    FlagCollected = 'flagCollected',

    PlayGame = 'playGame',
    StartTurn = 'startTurn',
    TurnStarting = 'turnStarting',
    EndTurn = 'endTurn',
    UpdateCountdown = 'updateCountdown',

    UpdateStartingCountdown = 'updateStartingCountdown',
    StartCombat = 'startCombat',
    CombatTurnStarted = 'combatTurnStarted',
    Attack = 'attack',
    AttackResult = 'attackResult',
    FlightAttempt = 'flightAttempt',
    FlightAttemptResult = 'flightAttemptResult',
    UpdateCombatCountDown = 'updateCombatCountDown',
    EndCombat = 'endCombat',

    ToggleDebugMode = 'toggleDebugMode',
    DebugModeEnabled = 'debugModeEnabled',
    DebugModeDisabled = 'debugModeDisabled',
    PlayerTeleported = 'playerTeleported',

    SendMessageToGameRoom = 'sendMessageToGameRoom',
    MassMessage = 'massMessage',

    GetStatistics = 'getStatistics',
    GetStatisticsResponse = 'getStatisticsResponse',

    GameRoomError = 'gameRoomError',
    UpdateScore = 'updateScore',
    DoorToggled = 'doorToggled',
    FinishGame = 'finishGame',

    VirtualPlayerTurn = 'virtualPlayerTurn',
    VirtualPlayerMoved = 'virtualPlayerMoved',

    SynchronizeMovement = 'synchronizeMovement',
    VirtualPlayerAttack = 'virtualPlayerAttack',
    StartVirtualCombat = 'startVirtualCombat',
    OrganizatorChanged = 'organizatorChanged',

    JoinGameRoom = 'joinGameRoom',
    JoinGameRoomResponse = 'joinGameRoomResponse',
    PlayerJoinedGame = 'playerJoinedGame',
}

export enum ChatEvents {
    Validate = 'validate',
    ValidateACK = 'validateWithAck',
    BroadcastAll = 'broadcastAll',
    JoinRoom = 'joinRoom',
    RoomMessage = 'roomMessage',

    WordValidated = 'wordValidated',
    MassMessage = 'massMessage',
    Hello = 'hello',
    Clock = 'clock',
}

export enum GeneralChatEvents {
    JoinGeneralChat = 'joinGeneralChat',
    LeaveGeneralChat = 'leaveGeneralChat',
    SendMessageToGeneralChat = 'sendMessageToGeneralChat',
    SendEmojiToGeneralChat = 'sendEmojiToGeneralChat',
    GeneralChatMessage = 'generalChatMessage',
    GeneralChatEmoji = 'generalChatEmoji',
    GetGeneralChatMessages = 'getGeneralChatMessages',
    GetGeneralChatMessagesResponse = 'getGeneralChatMessagesResponse',
    GeneralChatError = 'generalChatError',
}
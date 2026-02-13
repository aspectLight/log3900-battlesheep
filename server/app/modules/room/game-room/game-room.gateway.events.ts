export enum GameRoomEvents {
    CreateGameRoom = 'createGameRoom',
    GameRoomCreated = 'gameRoomCreated',

    AbandonGame = 'abandonGame',
    PlayerAbandoned = 'playerAbandoned',
    GameCanceled = 'gameCanceled',
    GameAbandoned = 'gameAbandoned',
    LeaveGameRoom = 'leaveGameRoom',
    PlayerLeft = 'playerLeft',
    GameRoomCanceled = 'GameRoomCanceled',

    PlayerGetMovements = 'playerGetMovements',
    PlayerSpawned = 'playerSpawned',
    PlayerMovements = 'playerMovements',
    PlayerMoved = 'playerMoved',

    PlayGame = 'playGame',
    StartTurn = 'startTurn',
    TurnStarting = 'turnStarting',
    EndTurn = 'endTurn',
    UpdateCountdown = 'updateCountdown',
    ResumeTurn = 'resumeTurn',

    StartCombat = 'startCombat',
    CombatTurnStarted = 'combatTurnStarted',
    Attack = 'attack',
    PerformAttack = 'performAttack',
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
    GetMessagesFromGameRoom = 'getMessagesFromGameRoom',
    GetMessagesResponse = 'getMessagesResponse',

    GetStatistics = 'getStatistics',
    GetStatisticsResponse = 'getStatisticsResponse',
    QuitEndGame = 'quitEndGame',

    GameRoomError = 'gameRoomError',
    UpdateScore = 'updateScore',
    DoorToggled = 'doorToggled',
    FinishGame = 'finishGame',
}

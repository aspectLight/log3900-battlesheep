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
    AvailableRoomsChanged = 'availableRoomsChanged',

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
    ResumeTurn = 'resumeTurn',
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

    TrapPending = 'trapPending',
    TrapChoice = 'trapChoice',
    TrapResult = 'trapResult',

    JoinGameRoom = 'joinGameRoom',
    JoinGameRoomResponse = 'joinGameRoomResponse',
    PlayerJoinedGame = 'playerJoinedGame',

    TorchIlluminationUpdate = 'torchIlluminationUpdate',
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
    AvatarUpdated = 'avatarUpdated',
}

export enum CustomChannelEvents {
    // Émis par le client
    CreateCustomChannel = 'createCustomChannel',
    JoinCustomChannel = 'joinCustomChannel',
    LeaveCustomChannel = 'leaveCustomChannel',
    DeleteCustomChannel = 'deleteCustomChannel',
    SendMessageToCustomChannel = 'sendMessageToCustomChannel',
    SendEmojiToCustomChannel = 'sendEmojiToCustomChannel',
    GetCustomChannelMessages = 'getCustomChannelMessages',
    ListCustomChannels = 'listCustomChannels',

    // Émis par le serveur
    CustomChannelCreated = 'customChannelCreated',
    CustomChannelMessage = 'customChannelMessage',
    CustomChannelEmoji = 'customChannelEmoji',
    CustomChannelMessagesResponse = 'customChannelMessagesResponse',
    CustomChannelsListResponse = 'customChannelsListResponse',
    CustomChannelJoined = 'customChannelJoined',
    CustomChannelLeft = 'customChannelLeft',
    CustomChannelDeleted = 'customChannelDeleted',
    CustomChannelError = 'customChannelError',
    UserChannelsRestored = 'userChannelsRestored', // Envoyé à la reconnexion pour restaurer les canaux rejoints
}

export enum CurrencyEvents {
    GetVirtualCurrency = 'getVirtualCurrency',
    VirtualCurrencyResponse = 'virtualCurrencyResponse',
    VirtualCurrencyUpdated = 'virtualCurrencyUpdated',
    GetShopCatalog = 'getShopCatalog',
    ShopCatalogResponse = 'shopCatalogResponse',
    PurchaseItem = 'purchaseItem',
    PurchaseItemResponse = 'purchaseItemResponse',
    GameRewardsInfo = 'gameRewardsInfo',
}

export enum SocialEvents {
    // Friend requests
    SendFriendRequest = 'sendFriendRequest',
    FriendRequestReceived = 'friendRequestReceived',
    AcceptFriendRequest = 'acceptFriendRequest',
    FriendRequestAccepted = 'friendRequestAccepted',
    RefuseFriendRequest = 'refuseFriendRequest',
    FriendRequestRefused = 'friendRequestRefused',
    CancelFriendRequest = 'cancelFriendRequest',
    FriendRequestCanceled = 'friendRequestCanceled',
    RemoveFriend = 'removeFriend',
    FriendRemoved = 'friendRemoved',

    // Block
    BlockUser = 'blockUser',
    UserBlocked = 'userBlocked',
    UnblockUser = 'unblockUser',
    UserUnblocked = 'userUnblocked',

    // State synchronization
    GetFriendsList = 'getFriendsList',
    FriendsListResponse = 'friendsListResponse',
    GetPendingRequests = 'getPendingRequests',
    PendingRequestsResponse = 'pendingRequestsResponse',
    GetBlockedUsers = 'getBlockedUsers',
    BlockedUsersResponse = 'blockedUsersResponse',
    GetUsersWhoBlockedMe = 'getUsersWhoBlockedMe',
    UsersWhoBlockedMeResponse = 'usersWhoBlockedMeResponse',

    // Friend presence
    FriendOnline = 'friendOnline',
    FriendOffline = 'friendOffline',

    // Waiting room warning
    BlockedUserInRoom = 'blockedUserInRoom',
    BlockedUserRoomChoice = 'blockedUserRoomChoice',

    SocialError = 'socialError',
}

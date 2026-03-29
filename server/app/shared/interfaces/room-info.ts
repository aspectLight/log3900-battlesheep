export interface RoomInfo {
    roomId: string;
    gameName: string;
    boardSize: number;
    board: any;
    mode: string;
    playerCount: number;
    maxPlayers: number;
    status: 'waiting' | 'playing';
    isLocked: boolean;
    dropInDropOut: boolean;
    friendsOnly: boolean;
    abandonedPlayerFirebaseIds?: string[];
    entryFee: number;
}

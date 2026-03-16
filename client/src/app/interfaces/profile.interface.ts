export interface UserProfile {
    id: string;
    email: string;
    username: string;
    avatarId: string;
    avatarUrl?: string | null;
    preferences?: Record<string, unknown>;
}

export interface UserStatistics {
    classicGamesPlayed: number;
    ctfGamesPlayed: number;
    totalGamesWon: number;
    averagePlaytimePerGame: number;
}

export interface UpdateProfilePayload {
    username?: string;
    email?: string;
    avatarId?: string;
}

export interface AvatarOption {
    id: string;
    label: string;
    image: string;
}

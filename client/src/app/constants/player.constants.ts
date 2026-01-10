export interface AvatarType {
    name: string;
    id: number;
    avatar: string;
    avatarFull: string;
}

export const AVATAR_TYPES: {
    [key: string]: AvatarType;
} = {
    viktor: {
        name: 'Viktor',
        id: 1,
        avatar: './assets/avatars/new/viktorAvatar.png',
        avatarFull: './assets/avatars/new/viktorFull.png',
    },
    petrov: {
        name: 'Petrov',
        id: 2,
        avatar: './assets/avatars/new/petrovAvatar.png',
        avatarFull: './assets/avatars/new/petrovFull.png',
    },
    dmitry: {
        name: 'Dmitry',
        id: 3,
        avatar: './assets/avatars/new/dmitryAvatar.png',
        avatarFull: './assets/avatars/new/dmitryFull.png',
    },
    ladeve: {
        name: 'Ladeve',
        id: 4,
        avatar: './assets/avatars/new/ladeveAvatar.png',
        avatarFull: './assets/avatars/new/ladeveFull.png',
    },
    irina: {
        name: 'Irina',
        id: 5,
        avatar: './assets/avatars/new/irinaAvatar.png',
        avatarFull: './assets/avatars/new/irinaFull.png',
    },
    sokolov: {
        name: 'Sokolov',
        id: 6,
        avatar: './assets/avatars/new/sokolovAvatar.png',
        avatarFull: './assets/avatars/new/sokolovFull.png',
    },
    georgie: {
        name: 'Georgie',
        id: 7,
        avatar: './assets/avatars/new/georgieAvatar.png',
        avatarFull: './assets/avatars/new/georgieFull.png',
    },
    misha: {
        name: 'Misha',
        id: 8,
        avatar: './assets/avatars/new/mishaAvatar.png',
        avatarFull: './assets/avatars/new/mishaFull.png',
    },
    gorkina: {
        name: 'Gorkina',
        id: 9,
        avatar: './assets/avatars/new/gorkinaAvatar.png',
        avatarFull: './assets/avatars/new/gorkinaFull.png',
    },
    sergei: {
        name: 'Sergei',
        id: 10,
        avatar: './assets/avatars/new/sergeiAvatar.png',
        avatarFull: './assets/avatars/new/sergeiFull.png',
    },
    ivanov: {
        name: 'Ivanov',
        id: 11,
        avatar: './assets/avatars/new/ivanovAvatar.png',
        avatarFull: './assets/avatars/new/ivanovFull.png',
    },
    volkov: {
        name: 'Volkov',
        id: 12,
        avatar: './assets/avatars/new/volkovAvatar.png',
        avatarFull: './assets/avatars/new/volkovFull.png',
    },
};

export const enum VirtualPlayerType {
    Aggressive = 'aggressive',
    Defensive = 'defensive',
}

export const DEFAULT_STATS_VALUE = 4;
export const DEFAULT_ACTION_POINTS = 1;
export const DEFAULT_MOVEMENT_POINTS = 4;
export const D4_VALUE = 4;
export const ADDER_VALUE = 3;
export const D6_VALUE = 6;
export const BONUS_VALUE = 2;

export const MAX_ENTITY_ID = 1000;

export const PROPAGANDA_HEALTH_THRESHOLD = 3;
export const PROPAGANDA_ATTACK_THRESHOLD = 6;

export const DELAY = 150;

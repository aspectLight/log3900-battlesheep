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
        avatar: './assets/avatars/viktorAvatar.png',
        avatarFull: './assets/avatars/viktorFull.png',
    },
    petrov: {
        name: 'Petrov',
        id: 2,
        avatar: './assets/avatars/petrovAvatar.png',
        avatarFull: './assets/avatars/petrovFull.png',
    },
    dmitry: {
        name: 'Dmitry',
        id: 3,
        avatar: './assets/avatars/dmitryAvatar.png',
        avatarFull: './assets/avatars/dmitryFull.png',
    },
    ladeve: {
        name: 'Ladeve',
        id: 4,
        avatar: './assets/avatars/ladeveAvatar.png',
        avatarFull: './assets/avatars/ladeveFull.png',
    },
    irina: {
        name: 'Irina',
        id: 5,
        avatar: './assets/avatars/irinaAvatar.png',
        avatarFull: './assets/avatars/irinaFull.png',
    },
    sokolov: {
        name: 'Sokolov',
        id: 6,
        avatar: './assets/avatars/sokolovAvatar.png',
        avatarFull: './assets/avatars/sokolovFull.png',
    },
    georgie: {
        name: 'Georgie',
        id: 7,
        avatar: './assets/avatars/georgieAvatar.png',
        avatarFull: './assets/avatars/georgieFull.png',
    },
    misha: {
        name: 'Misha',
        id: 8,
        avatar: './assets/avatars/mishaAvatar.png',
        avatarFull: './assets/avatars/mishaFull.png',
    },
    gorkina: {
        name: 'Gorkina',
        id: 9,
        avatar: './assets/avatars/gorkinaAvatar.png',
        avatarFull: './assets/avatars/gorkinaFull.png',
    },
    sergei: {
        name: 'Sergei',
        id: 10,
        avatar: './assets/avatars/sergeiAvatar.png',
        avatarFull: './assets/avatars/sergeiFull.png',
    },
    ivanov: {
        name: 'Ivanov',
        id: 11,
        avatar: './assets/avatars/ivanovAvatar.png',
        avatarFull: './assets/avatars/ivanovFull.png',
    },
    volkov: {
        name: 'Volkov',
        id: 12,
        avatar: './assets/avatars/volkovAvatar.png',
        avatarFull: './assets/avatars/volkovFull.png',
    },
};

export const DEFAULT_STATS_VALUE = 4;
export const DEFAULT_ACTION_POINTS = 1;
export const DEFAULT_MOVEMENT_POINTS = 4;
export const D4_VALUE = 4;
export const ADDER_VALUE = 3;
export const D6_VALUE = 6;
export const BONUS_VALUE = 2;

export const MAX_ENTITY_ID = 1000;

export enum ErrorMessages {
    GameDeleted = 'Le jeu a déjà été supprimé.',
    GenericError = 'Une erreur est survenue. Veuillez réessayer.',
    InvalidPosition = 'Invalid position',
    InvalidItem = 'Invalid item type: ',
    InvalidTile = 'Invalid tile type:',
    InvalidBoardSize = 'Invalid board size: ',
    JoinImpossible = 'Impossible de rejoindre la salle.',
    NameAlreadyUsed = 'Le nom choisi pour le jeu est déjà utilisé. Veuillez le changer.',
    GameDeletedOrLocked = 'La partie a été verrouillée ou supprimée',
    PlayerKicked = 'Vous avez été expulsé de la partie',
    HostLeft = "L'organisateur a quitté la partie",
    RoomFull = 'La salle est pleine',
    RoomLocked = 'La salle est verrouillée',
    QuitError = 'Erreur lors de la sortie de la salle',
    GameShouldHaveName = 'Le jeu doit avoir un nom.',
    GameSoudlHaveDescription = 'Le jeu doit avoir une description.',
    HalfTilesCoverage = 'Plus de 50% de la surface totale de la zone de jeu doit être occupée par des tuiles de terrain.',
    NoTerrainTiles = "Aucune tuile de terrain n'a été trouvée.",
    AllTerrainTilesAccessible = 'Toutes les tuiles de terrain doivent être accessibles.',
}

export const SPECIFIC_ERROR = {
    minSpawnPoints: (requiredPoints: number): string => `Il doit y avoir ${requiredPoints} points de départ.`,
    minItems: (requiredItems: number): string => `Il doit y avoir ${requiredItems} items.`,
    notOnEdge: (x: number, y: number): string => `La porte à (${x}, ${y}) est sur le bord du plateau.`,
    surroundedByWalls: (x: number, y: number): string => `La porte à (${x}, ${y}) n'est pas entourée par des murs sur le même axe.`,
    surroundedByTerrain: (x: number, y: number): string => `La porte à (${x}, ${y}) n'est pas entourée par des tuiles de terrain sur le même axe.`,
};

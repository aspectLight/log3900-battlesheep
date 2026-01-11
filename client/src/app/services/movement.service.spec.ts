import { TestBed } from '@angular/core/testing';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Player } from '@app/classes/player';
import { Tile } from '@app/classes/tile';
import { BonusType } from '@app/constants/bonus.constants';
import { MovementService } from './movement.service';

describe('MovementService', () => {
    let service: MovementService;
    let mockPlayer: Player;
    let mockBoard: Board;
    let mockCell: Cell;

    beforeEach(() => {
        TestBed.configureTestingModule({});
        service = TestBed.inject(MovementService);

        mockPlayer = new Player('testPlayer');
        mockBoard = new Board(10);
        mockCell = new Cell(new Tile('ice'), 1, 1);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should select a player', () => {
        service.selectPlayer(mockPlayer);
        expect(service.selectedPlayer).toBe(mockPlayer);
    });

    it('should not move a player if no player is selected', () => {
        expect(service.movePlayer(mockBoard, 1, 1)).toEqual({ success: false });
    });

    it('should not move a player if the player is dead', () => {
        service.selectPlayer(mockPlayer);
        mockPlayer.setStatValue(BonusType.Health, 0);
        expect(service.movePlayer(mockBoard, 1, 1)).toEqual({ success: false });
    });

    it('should not move a player if the player has no cell', () => {
        mockPlayer.cell = null;
        service.selectPlayer(mockPlayer);
        expect(service.movePlayer(mockBoard, 1, 1)).toEqual({ success: false });
    });

    it('should not move a player if the target cell is out of bounds', () => {
        mockPlayer.cell = mockCell;
        service.selectPlayer(mockPlayer);
        expect(service.movePlayer(mockBoard, 1, 11)).toEqual({ success: false });
    });

    it('should not move a player if the target cell is occupied', () => {
        mockPlayer.cell = mockCell;
        service.selectPlayer(mockPlayer);
        const targetCell = new Cell(new Tile('ice'), 2, 2);
        targetCell.player = new Player('anotherPlayer');
        mockBoard.matrix[2][2] = targetCell;
        expect(service.movePlayer(mockBoard, 1, 1)).toEqual({ success: false });
    });

    it('should not move a player on a cell with a wall', () => {
        mockPlayer.cell = mockCell;
        service.selectPlayer(mockPlayer);
        const targetCell = new Cell(new Tile('wall'), 2, 2);
        mockBoard.matrix[2][2] = targetCell;
        expect(service.movePlayer(mockBoard, 1, 1)).toEqual({ success: false });
    });

    it('should move a player to the target cell', () => {
        mockPlayer.cell = mockCell;
        service.selectPlayer(mockPlayer);
        const targetCell = new Cell(new Tile('ice'), 1, 2);
        mockBoard.matrix[1][2] = targetCell;
        expect(service.movePlayer(mockBoard, 0, 1)).toEqual({ success: true, cell: targetCell });
        expect(mockPlayer.cell).toBe(targetCell);
    });

    it('should teleport a player to the target cell', () => {
        mockPlayer.cell = mockCell;
        service.selectPlayer(mockPlayer);
        const targetCell = new Cell(new Tile('ice'), 1, 2);
        mockBoard.matrix[1][2] = targetCell;
        expect(service.teleportPlayer(mockBoard, 1, 2)).toBe(true);
        expect(mockPlayer.cell).toEqual(targetCell);
    });

    it('should stop a player', () => {
        mockPlayer.setState('moving');
        service.stopPlayer(mockPlayer);
        expect(mockPlayer.animationState).toBe('idle');
    });

    it('should move a player along a path', async () => {
        mockPlayer.cell = mockCell;
        service.selectPlayer(mockPlayer);
        const targetCell = new Cell(new Tile('snow'), 1, 2);
        mockBoard.matrix[1][2] = targetCell;
        const paths = [mockCell, targetCell];
        await service.movePlayerFromPath(mockBoard, paths);
        expect(mockPlayer.cell).toEqual(targetCell);
    });

    it('should not move a player along a path if no player is selected', async () => {
        const initialCell = new Cell(new Tile('ice'), 1, 1);
        mockPlayer.cell = initialCell;
        service.selectedPlayer = undefined as unknown as Player;
        const paths = [initialCell];
        await service.movePlayerFromPath(mockBoard, paths);
        expect(mockPlayer.cell).toBe(initialCell);
    });

    it('should not move a player along a path if the player has no cell', async () => {
        mockPlayer.cell = null;
        service.selectPlayer(mockPlayer);
        const paths = [mockCell];
        await service.movePlayerFromPath(mockBoard, paths);
        expect(mockPlayer.cell).toBeNull();
    });

    it('should return false if a move along the path fails', async () => {
        // Setup: assign the player with a starting cell at (1,1)
        mockPlayer.cell = new Cell(new Tile('ice'), 1, 1);
        service.selectPlayer(mockPlayer);

        // Override movePlayer to simulate a failure (return false)
        spyOn(service, 'movePlayer').and.returnValue({ success: false });

        // Define a path: first element is the starting cell, second is the target coordinate
        const nextCoords = { x: 2, y: 2 };
        const paths = [mockPlayer.cell, nextCoords];

        // Call movePlayerFromPath; it should return false because movePlayer fails
        const result = await service.movePlayerFromPath(mockBoard, paths);

        expect(result).toEqual({ success: false });
    });

    it('should return false if the cell has a player', () => {
        const cellWithPlayer = new Cell(new Tile('ice'), 0, 0);
        cellWithPlayer.player = new Player('testPlayer');
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const result = (service as any).isCellFree(cellWithPlayer);
        expect(result).toBeFalse();
    });

    it('should return false if the cell tile type is "wall"', () => {
        const cellWall = new Cell(new Tile('wall'), 0, 0);
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const result = (service as any).isCellFree(cellWall);
        expect(result).toBeFalse();
    });

    it('should return false if the cell tile is a door and state is "closed"', () => {
        const doorTile = new Tile('door');
        doorTile.state = 'closed';
        const cellDoor = new Cell(doorTile, 0, 0);
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const result = (service as any).isCellFree(cellDoor);
        expect(result).toBeFalse();
    });

    it('should return true if none of the conditions are met', () => {
        const freeCell = new Cell(new Tile('ice'), 0, 0);
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        const result = (service as any).isCellFree(freeCell);
        expect(result).toBeTrue();
    });

    it('should set orientation to left if dy < 0', () => {
        service['updatePlayerOrientation'](mockPlayer, 0, -1);
        expect(mockPlayer.orientation).toBe('left');
    });

    it('should set orientation to up if dx < 0', () => {
        service['updatePlayerOrientation'](mockPlayer, -1, 0);
        expect(mockPlayer.orientation).toBe('up');
    });

    it('should return false if target cell is not found', () => {
        service.selectPlayer(mockPlayer);
        const result = service.teleportPlayer(mockBoard, 10, 10);
        expect(result).toBeFalse();
    });

    it('should return false if target cell is not free', () => {
        service.selectPlayer(mockPlayer);
        const nonFreeCell = new Cell(new Tile('wall'), 1, 2);
        mockBoard.matrix[1][2] = nonFreeCell;
        const result = service.teleportPlayer(mockBoard, 1, 2);
        expect(result).toBeFalse();
    });

    it('should return false if no player is selected', () => {
        // Ensure no player is selected
        service.selectedPlayer = undefined as unknown as Player;
        const result = service.teleportPlayer(mockBoard, 1, 2);
        expect(result).toBeFalse();
    });

    describe('isMoving', () => {
        it('should return true if the player is moving', () => {
            service.selectPlayer(mockPlayer);
            mockPlayer.setState('moving');
            expect(service.isMoving()).toBeTrue();
        });

        it('should return true if a path execution is in progress', () => {
            service['isExecutingPath'] = true;
            expect(service.isMoving()).toBeTrue();
        });

        it('should return false if player is not moving and no path execution is in progress', () => {
            service['isExecutingPath'] = false;
            service.selectPlayer(mockPlayer);
            mockPlayer.setState('idle');
            expect(service.isMoving()).toBeFalse();
        });

        it('should return false if no player is selected', () => {
            service['isExecutingPath'] = false;
            service.selectedPlayer = undefined as unknown as Player;
            expect(service.isMoving()).toBeFalse();
        });
    });

    it('should return false if movingPlayer becomes null during path execution', async () => {
        // Setup: assign the player with a starting cell at (1,1)
        mockPlayer.cell = new Cell(new Tile('ice'), 1, 1);
        service.selectPlayer(mockPlayer);

        // Define a path with multiple steps
        const paths = [mockPlayer.cell, { x: 2, y: 2 }, { x: 3, y: 3 }];

        // Override movePlayer to make movingPlayer null after first move
        spyOn(service, 'movePlayer').and.callFake(() => {
            service['movingPlayer'] = null;
            return { success: true };
        });

        const result = await service.movePlayerFromPath(mockBoard, paths);
        expect(result).toEqual({ success: false });
    });

    it('should handle errors during path execution', async () => {
        // Setup: assign the player with a starting cell at (1,1)
        mockPlayer.cell = new Cell(new Tile('ice'), 1, 1);
        service.selectPlayer(mockPlayer);

        // Define a path with multiple steps
        const paths = [mockPlayer.cell, { x: 2, y: 2 }, { x: 3, y: 3 }];

        // Override movePlayer to throw an error
        spyOn(service, 'movePlayer').and.throwError('Test error');

        const result = await service.movePlayerFromPath(mockBoard, paths);
        expect(result).toEqual({ success: false });
        expect(service['isExecutingPath']).toBeFalse();
        expect(service['movingPlayer']).toBeNull();
    });
});

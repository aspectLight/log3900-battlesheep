/* eslint-disable max-lines */
import { TestBed } from '@angular/core/testing';
import { Board } from '@app/classes/board';
import { Cell } from '@app/classes/cell';
import { Player } from '@app/classes/player';
import { Tile } from '@app/classes/tile';
import { ActionService } from './action.service';
import { CombatService } from './combat.service';
import { GameManagerService } from './game-manager.service';
import { SocketService } from './socket.service';
import { ActionSocketService } from '@app/services/socket/action/action-socket.service';
import { MovementSocketService } from '@app/services/socket/movement/movement-socket.service';
describe('ActionService', () => {
    let service: ActionService;
    let gameManagerServiceMock: jasmine.SpyObj<GameManagerService>;
    let combatServiceMock: jasmine.SpyObj<CombatService>;
    let actionSocketServiceMock: jasmine.SpyObj<ActionSocketService>;
    let movementSocketServiceMock: jasmine.SpyObj<MovementSocketService>;
    let socketServiceMock: jasmine.SpyObj<SocketService>;
    let mockPlayer: Player;
    let mockEnemy: Player;
    let mockBoard: jasmine.SpyObj<Board>;
    let mockCell: Cell;
    let mockDoorCell: Cell;

    beforeEach(() => {
        // Create mock player
        mockPlayer = new Player('TestPlayer');
        mockPlayer.actionPoints = 1;

        mockEnemy = new Player('TestEnemy');

        mockBoard = jasmine.createSpyObj('Board', ['getPlayerById', 'getCell']);

        mockCell = new Cell(new Tile('snow'), 1, 1);
        mockDoorCell = new Cell(new Tile('door'), 1, 1);

        const playerCell = new Cell(new Tile('snow'), 0, 0);
        mockPlayer.addCell(playerCell);

        gameManagerServiceMock = jasmine.createSpyObj('GameManagerService', ['getBoard', 'isDebugMode', 'getMainPlayer'], {
            movementService: {
                selectedPlayer: mockPlayer,
            },
            isPlayerTurn: true,
        });
        gameManagerServiceMock.getMainPlayer.and.returnValue(mockPlayer);
        gameManagerServiceMock.getBoard.and.returnValue(mockBoard);
        mockBoard.getPlayerById.and.returnValue(mockPlayer);

        combatServiceMock = jasmine.createSpyObj('CombatService', ['getEnemy', 'setEnemy', 'startCombat']);
        combatServiceMock.getEnemy.and.returnValue(mockEnemy);
        combatServiceMock.startCombat.and.returnValue({ roomId: 'test-room', opponentId: 'test-opponent' });

        actionSocketServiceMock = jasmine.createSpyObj('ActionSocketService', ['startCombat', 'toggleDoor', 'teleportPlayer']);
        movementSocketServiceMock = jasmine.createSpyObj('MovementSocketService', ['teleportPlayer']);
        socketServiceMock = jasmine.createSpyObj('SocketService', ['teleportPlayer']);
        TestBed.configureTestingModule({
            providers: [
                ActionService,
                { provide: GameManagerService, useValue: gameManagerServiceMock },
                { provide: CombatService, useValue: combatServiceMock },
                { provide: ActionSocketService, useValue: actionSocketServiceMock },
                { provide: MovementSocketService, useValue: movementSocketServiceMock },
                { provide: SocketService, useValue: socketServiceMock },
            ],
        });

        service = TestBed.inject(ActionService);
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    describe('Properties', () => {
        it('should have selectedCell observable', () => {
            let result: Cell | null = null;
            service.selectedCell$.subscribe((cell) => {
                result = cell;
            });
            expect(result).toBeNull();
        });

        it('should have isSelectionActive observable', () => {
            let result: boolean | null = null;
            service.isSelectionActive$.subscribe((isActive) => {
                result = isActive;
            });
            expect(result).toBeFalse();
        });

        it('should get player from gameManager', () => {
            expect(service.player).toBe(mockPlayer);
        });

        it('should get enemy from combatService', () => {
            expect(service.enemy).toBe(mockEnemy);
        });

        it('should get isSelectionActive value', () => {
            expect(service.getIsSelectionActive()).toBeFalse();
        });

        it('should get isActionActive value', () => {
            expect(service.getIsActionActive()).toBeFalse();
        });
    });

    describe('Selection methods', () => {
        it('should toggle selection state', () => {
            expect(service.getIsSelectionActive()).toBeFalse();
            service.toggleSelection();
            expect(service.getIsSelectionActive()).toBeTrue();
            service.toggleSelection();
            expect(service.getIsSelectionActive()).toBeFalse();
        });

        it('should set selection active', () => {
            service.setSelectionActive(true);
            expect(service.getIsSelectionActive()).toBeTrue();
        });

        it('should select cell when selection is active', () => {
            service.setSelectionActive(true);
            let selectedCell: Cell | null = null;
            service.selectedCell$.subscribe((cell) => {
                selectedCell = cell;
            });

            service.selectCell(mockCell);
            expect(selectedCell).not.toBeNull();
            expect(selectedCell).toBeTruthy();
        });

        it('should not select cell when selection is inactive', () => {
            service.setSelectionActive(false);
            let selectedCell: Cell | null = null;
            service.selectedCell$.subscribe((cell) => {
                selectedCell = cell;
            });

            service.selectCell(mockCell);
            expect(selectedCell).toBeNull();
        });

        it('should select single cell regardless of selection state', () => {
            service.setSelectionActive(false);
            let selectedCell: Cell | null = null;
            service.selectedCell$.subscribe((cell) => {
                selectedCell = cell;
            });

            service.selectSingleCell(mockCell);
            expect(selectedCell).not.toBeNull();
            expect(selectedCell).toBeTruthy();
        });

        it('should toggle action state and set selection to false', () => {
            // Initial state
            expect(service.getIsActionActive()).toBeFalse();
            expect(service.getIsSelectionActive()).toBeFalse();

            // Toggle action on
            service.toggleAction();
            expect(service.getIsActionActive()).toBeTrue();
            expect(service.getIsSelectionActive()).toBeFalse();

            // Toggle action off
            service.toggleAction();
            expect(service.getIsActionActive()).toBeFalse();
            expect(service.getIsSelectionActive()).toBeFalse();

            // Test that selection is set to false even when toggling action
            service.setSelectionActive(true);
            expect(service.getIsSelectionActive()).toBeTrue();
            service.toggleAction();
            expect(service.getIsSelectionActive()).toBeFalse();
        });

        it('should set action active state directly', () => {
            // Initial state
            expect(service.getIsActionActive()).toBeFalse();

            // Set action active to true
            service.setActionActive(true);
            expect(service.getIsActionActive()).toBeTrue();

            // Set action active to false
            service.setActionActive(false);
            expect(service.getIsActionActive()).toBeFalse();
        });
    });

    describe('switchModes', () => {
        it('should switch from selection to action mode', () => {
            service.setSelectionActive(true);
            service.setActionActive(false);
            service.switchModes();

            expect(service.getIsSelectionActive()).toBeFalse();
            expect(service.getIsActionActive()).toBeTrue();
        });

        it('should switch from action mode to selection mode', () => {
            service.setSelectionActive(false);
            service.setActionActive(true);
            service.switchModes();

            expect(service.getIsSelectionActive()).toBeTrue();
            expect(service.getIsActionActive()).toBeFalse();

            let selectedCell: Cell | null = mockCell;
            service.selectedCell$.subscribe((cell) => (selectedCell = cell));
            expect(selectedCell).toBeNull();
        });

        it('should switch from none to selection mode', () => {
            service.setSelectionActive(false);
            service.setActionActive(false);
            service.switchModes();

            expect(service.getIsSelectionActive()).toBeTrue();
            expect(service.getIsActionActive()).toBeFalse();
        });
    });

    describe('Combat methods', () => {
        let cellWithPlayer: Cell;

        beforeEach(() => {
            cellWithPlayer = new Cell(new Tile('snow'), 1, 0);
            cellWithPlayer.player = mockEnemy;
        });

        it('should not start combat if cell.player is undefined', () => {
            const cell = new Cell(new Tile('snow'), 1, 0);
            expect(service.startCombat(cell)).toBeUndefined();
        });

        it('should start combat and emit socket event', () => {
            service.startCombat(cellWithPlayer);
            expect(combatServiceMock.startCombat).toHaveBeenCalledWith(mockEnemy);
            expect(actionSocketServiceMock.startCombat).toHaveBeenCalledWith({
                roomId: 'test-room',
                opponentId: 'test-opponent',
            });
        });

        it('should not start combat if startCombat returns null', () => {
            combatServiceMock.startCombat.and.returnValue(null);
            service.startCombat(cellWithPlayer);
            expect(combatServiceMock.startCombat).toHaveBeenCalled();
            expect(actionSocketServiceMock.startCombat).not.toHaveBeenCalled();
        });

        it('should set enemy from cell player property', () => {
            const enemyPlayer = new Player('CellEnemy');
            const cellWithCustomPlayer = new Cell(new Tile('snow'), 1, 0);
            cellWithCustomPlayer.player = enemyPlayer;

            service.startCombat(cellWithCustomPlayer);
            expect(combatServiceMock.setEnemy).toHaveBeenCalledWith(enemyPlayer);
        });
    });

    describe('Action points', () => {
        it('should not remove action points when no player exists', () => {
            gameManagerServiceMock.getMainPlayer.and.returnValue(null);
            service.removeActionPoints();
            expect(mockPlayer.actionPoints).toBe(1);
        });

        it('should remove action points when not in debug mode', () => {
            Object.defineProperty(gameManagerServiceMock, 'isDebugMode', { get: () => false });
            mockPlayer.actionPoints = 1;
            service.removeActionPoints();
            expect(mockPlayer.actionPoints).toBe(0);
        });

        it('should not remove action points in debug mode', () => {
            Object.defineProperty(gameManagerServiceMock, 'isDebugMode', { get: () => true });
            mockPlayer.actionPoints = 1;
            service.removeActionPoints();
            expect(mockPlayer.actionPoints).toBe(1);
        });
    });

    describe('Door interaction', () => {
        it('should toggle door and emit socket event', () => {
            service.toggleDoor(mockDoorCell);
            expect(actionSocketServiceMock.toggleDoor).toHaveBeenCalledWith(mockDoorCell.x, mockDoorCell.y);
        });
    });

    describe('Cell proximity check', () => {
        it('should return false from isCellCloseToPlayer when no player exists', () => {
            gameManagerServiceMock.getMainPlayer.and.returnValue(null);
            expect(service.isCellCloseToPlayer()).toBeFalse();
        });

        it('should return true when cell is adjacent horizontally', () => {
            // Player is at (0,0)
            const adjacentCell = new Cell(new Tile('snow'), 1, 0);
            service.selectSingleCell(adjacentCell);
            expect(service.isCellCloseToPlayer()).toBeTrue();
        });

        it('should return true when cell is adjacent vertically', () => {
            // Player is at (0,0)
            const adjacentCell = new Cell(new Tile('snow'), 0, 1);
            service.selectSingleCell(adjacentCell);
            expect(service.isCellCloseToPlayer()).toBeTrue();
        });

        it('should return false when cell is diagonal', () => {
            const diagonalCell = new Cell(new Tile('snow'), 1, 1);
            service.selectSingleCell(diagonalCell);
            expect(service.isCellCloseToPlayer()).toBeFalse();
        });

        it('should return false when cell is not adjacent', () => {
            const farCell = new Cell(new Tile('snow'), 2, 0);
            service.selectSingleCell(farCell);
            expect(service.isCellCloseToPlayer()).toBeFalse();
        });

        it('should return false when player is not found', () => {
            mockBoard.getPlayerById.and.returnValue(null);
            service.selectSingleCell(mockCell);
            expect(service.isCellCloseToPlayer()).toBeFalse();
        });

        it('should return false when player cell is undefined', () => {
            const playerWithoutCell = new Player('NoCell');
            Object.defineProperty(gameManagerServiceMock.movementService, 'selectedPlayer', { get: () => playerWithoutCell });
            mockBoard.getPlayerById.and.returnValue(playerWithoutCell);

            service.selectSingleCell(mockCell);
            expect(service.isCellCloseToPlayer()).toBeFalse();
        });

        it('should return false when selected cell is null', () => {
            service.selectSingleCell(null as unknown as Cell);
            expect(service.isCellCloseToPlayer()).toBeFalse();
        });
    });

    describe('Interact method', () => {
        beforeEach(() => {
            // Ensure isCellCloseToPlayer returns true for adjacent cells
            spyOn(service, 'isCellCloseToPlayer').and.returnValue(true);
            // Set debug mode to false to allow action points to be removed
            Object.defineProperty(gameManagerServiceMock, 'isDebugMode', { get: () => false });
            // Ensure it's player's turn
            Object.defineProperty(gameManagerServiceMock, 'isPlayerTurn', { get: () => true });
        });

        it('should not interact when no player exists', () => {
            gameManagerServiceMock.getMainPlayer.and.returnValue(null);
            service.interact();
            expect(actionSocketServiceMock.toggleDoor).not.toHaveBeenCalled();
            expect(combatServiceMock.startCombat).not.toHaveBeenCalled();
        });

        it('should not interact when no cell is selected', () => {
            service.selectSingleCell(null as unknown as Cell);
            service.interact();
            expect(actionSocketServiceMock.toggleDoor).not.toHaveBeenCalled();
            expect(combatServiceMock.startCombat).not.toHaveBeenCalled();
        });

        it('should not interact when player has no action points', () => {
            mockPlayer.actionPoints = 0;
            const adjacentCell = new Cell(new Tile('snow'), 1, 0);
            service.selectSingleCell(adjacentCell);
            service.interact();
            expect(actionSocketServiceMock.toggleDoor).not.toHaveBeenCalled();
            expect(combatServiceMock.startCombat).not.toHaveBeenCalled();
        });

        it('should toggle closed door when interacting with it', () => {
            const doorCell = new Cell(new Tile('door'), 1, 0);
            doorCell.tile.state = 'closed';
            service.selectSingleCell(doorCell);
            service.interact();
            expect(actionSocketServiceMock.toggleDoor).toHaveBeenCalledWith(doorCell.x, doorCell.y);
            expect(mockPlayer.actionPoints).toBe(0);
        });

        it('should toggle open door when interacting with it', () => {
            const doorCell = new Cell(new Tile('door'), 1, 0);
            doorCell.tile.state = 'opened';
            service.selectSingleCell(doorCell);
            service.interact();
            expect(actionSocketServiceMock.toggleDoor).toHaveBeenCalledWith(doorCell.x, doorCell.y);
            expect(mockPlayer.actionPoints).toBe(0);
        });

        it('should not toggle door if player is on it', () => {
            const doorCell = new Cell(new Tile('door'), 1, 0);
            doorCell.tile.state = 'opened';
            doorCell.player = new Player('DoorPlayer');
            service.selectSingleCell(doorCell);
            service.interact();
            expect(actionSocketServiceMock.toggleDoor).not.toHaveBeenCalled();
            expect(combatServiceMock.startCombat).toHaveBeenCalled();
            expect(mockPlayer.actionPoints).toBe(0);
        });

        it('should start combat when interacting with cell containing player', () => {
            const cellWithPlayer = new Cell(new Tile('snow'), 1, 0);
            cellWithPlayer.player = new Player('EnemyPlayer');
            service.selectSingleCell(cellWithPlayer);
            service.interact();
            expect(combatServiceMock.startCombat).toHaveBeenCalled();
            expect(mockPlayer.actionPoints).toBe(0);
        });

        it('should handle remote actions when cell is not adjacent', () => {
            // Override the spy for this test only
            (service.isCellCloseToPlayer as jasmine.Spy).and.returnValue(false);

            const farCell = new Cell(new Tile('snow'), 2, 0);
            farCell.player = new Player('FarEnemy');
            service.selectSingleCell(farCell);
            service.interact();
            expect(combatServiceMock.startCombat).not.toHaveBeenCalled();
            expect(actionSocketServiceMock.toggleDoor).not.toHaveBeenCalled();
        });

        it('should start combat with air strike when cell is not adjacent and player has air strike item', () => {
            // Override the spy for this test only
            (service.isCellCloseToPlayer as jasmine.Spy).and.returnValue(false);

            // Add air strike item to player
            spyOn(mockPlayer, 'hasItem').and.returnValue(true);

            const farCell = new Cell(new Tile('snow'), 2, 0);
            farCell.player = new Player('FarEnemy');
            service.selectSingleCell(farCell);
            service.interact();

            expect(combatServiceMock.startCombat).toHaveBeenCalled();
            expect(mockPlayer.actionPoints).toBe(0);
        });

        it('should teleport player when cell is not adjacent and player has camouflage item', () => {
            // Override the spy for this test only
            (service.isCellCloseToPlayer as jasmine.Spy).and.returnValue(false);

            // Add camouflage item to player
            spyOn(mockPlayer, 'hasItem').and.returnValue(true);

            const farCell = new Cell(new Tile('snow'), 2, 0);
            service.selectSingleCell(farCell);
            service.interact();

            expect(socketServiceMock.teleportPlayer).toHaveBeenCalledWith(farCell.x, farCell.y, '', true);
            expect(mockPlayer.actionPoints).toBe(0);
        });

        it('should start combat with enemy player in CTF mode if they are on different teams', () => {
            // Set up CTF mode
            Object.defineProperty(gameManagerServiceMock, 'isCTF', { get: () => true });

            // Create players with different teams
            mockPlayer.team = 1;
            const enemyPlayer = new Player('EnemyPlayer');
            enemyPlayer.team = 2;

            const cellWithEnemy = new Cell(new Tile('snow'), 1, 0);
            cellWithEnemy.player = enemyPlayer;

            service.selectSingleCell(cellWithEnemy);
            service.interact();

            expect(combatServiceMock.startCombat).toHaveBeenCalled();
            expect(mockPlayer.actionPoints).toBe(0);
        });

        it('should not start combat with ally player in CTF mode if they are on the same team', () => {
            // Set up CTF mode
            Object.defineProperty(gameManagerServiceMock, 'isCTF', { get: () => true });

            // Create players with the same team
            mockPlayer.team = 1;
            const allyPlayer = new Player('AllyPlayer');
            allyPlayer.team = 1;

            const cellWithAlly = new Cell(new Tile('snow'), 1, 0);
            cellWithAlly.player = allyPlayer;

            service.selectSingleCell(cellWithAlly);
            service.interact();

            expect(combatServiceMock.startCombat).not.toHaveBeenCalled();
            expect(mockPlayer.actionPoints).toBe(1); // Action points should not be consumed
        });
    });
});

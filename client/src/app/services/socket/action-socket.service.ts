import { Injectable } from '@angular/core';
import { SocketService } from '@app/services/socket.service';
import { Observable, Subject } from 'rxjs';
import { Socket } from 'socket.io-client';
import { GameManagerService } from '@app/services/game-manager.service';
import { ISocketService } from '@app/interfaces/socket-service.interface';
import { AttackPayload, AttackResult, CombatPayload, FlightResult } from '@app/interfaces/payload';
import { CombatService } from '@app/services/combat.service';
import { GameRoomService } from '@app/services/game-room.service';
import { GameRoomEvents } from '@common/socket.constants';
import { MovementSocketService } from './movement-socket.service';
import { Player } from '@app/classes/player';
@Injectable({
    providedIn: 'root',
})
export class ActionSocketService implements ISocketService {
    socket: Socket;
    attackTrigger: Observable<void>;
    private attackTriggerSubject: Subject<void> = new Subject<void>();

    constructor(
        private socketService: SocketService,
        private movementSocketService: MovementSocketService,
        private gameManagerService: GameManagerService,
        private combatService: CombatService,
        private gameRoomService: GameRoomService,
    ) {
        this.socketService.registerSocketService(this);
        this.setUpConnection();
    }

    setUpConnection(): void {
        this.socket = this.socketService.socket;
        this.attackTrigger = this.attackTriggerSubject.asObservable();
        this.setUpListeners();
    }

    toggleDebugMode(): void {
        const room = this.gameManagerService.room;
        if (this.gameManagerService.currentPlayerId === this.socket.id && room.organisatorId === this.socket.id) {
            this.socket.emit(GameRoomEvents.ToggleDebugMode, room.roomId);
        }
    }

    startCombat(combatPayload: CombatPayload) {
        this.socket.emit(GameRoomEvents.StartCombat, combatPayload);
    }

    flightAttempt(combatPayload: CombatPayload) {
        this.socket.emit(GameRoomEvents.FlightAttempt, combatPayload.roomId);
    }

    attack(attackPayload: AttackPayload) {
        this.socket.emit(GameRoomEvents.Attack, attackPayload);
    }

    toggleDoor(x: number, y: number) {
        const roomId = this.gameManagerService.room.roomId;
        this.socket.emit(GameRoomEvents.DoorToggled, { roomId, x, y });
    }

    addToJournal(entry: { type: string; content: string }): void {
        const roomId = this.gameManagerService.room.roomId;
        this.socket.emit(GameRoomEvents.AddJournalEntry, { roomId, entry });
    }

    private setUpListeners(): void {
        this.socket.on(GameRoomEvents.PerformAttack, () => {
            this.attackTriggerSubject.next();
        });

        this.socket.on(GameRoomEvents.AttackResult, (data: AttackResult) => {
            this.combatService.handleAttackResult(data);
        });

        this.socket.on(GameRoomEvents.FlightAttemptResult, (data: FlightResult) => {
            this.combatService.showFlightResult(data);
            this.combatService.handleFlightResult(data);
        });

        this.socket.on(GameRoomEvents.CombatTurnStarted, (combatRoom) => {
            this.combatService.setIsCombatPlayerTurn(false);
            if (combatRoom.currentPlayerId === this.socketService.getId()) {
                this.combatService.setIsCombatPlayerTurn(true);
            }
            if (!this.combatService.isCombatMode) {
                this.combatService.setCombatRoom(combatRoom);
            }
        });

        this.socket.on(
            GameRoomEvents.CalculateVirtualPlayerAttack,
            (isVirtualCombatOnly: boolean, playerAttackingId: string, playerDefendingId: string, combatRoomId: string) => {
                const playerAttacking = this.gameManagerService.getPlayerById(playerAttackingId) as Player;
                const playerDefending = this.gameManagerService.getPlayerById(playerDefendingId) as Player;
                if (isVirtualCombatOnly) {
                    const attackInfos = this.combatService.getVirtualPlayerAttack(playerAttacking, playerDefending, combatRoomId);
                    this.attack(attackInfos);
                } else {
                    this.attackTriggerSubject.next();
                }
            },
        );

        this.socket.on(GameRoomEvents.EndCombat, (winnerId, loserId) => {
            this.combatService.handleEnd(winnerId, loserId);
            const loser = this.gameManagerService.room.players.find((p) => p.id === loserId);
            const organisatorId = this.gameManagerService.room.organisatorId;
            if (this.socket.id === this.combatService.loserId || (loser?.isVirtual && this.socket.id === organisatorId)) {
                if (loser) this.socketService.teleportPlayer(loser?.spawnPoint.x, loser?.spawnPoint.y, loser?.id);
                this.combatService.loserId = '';
                this.addToJournal({
                    type: 'TOUS',
                    content: `Fin du combat ! ${this.gameManagerService.getPlayerById(winnerId)?.name} a battu ${loser?.name}.`,
                });
            }
        });

        this.socket.on(GameRoomEvents.DebugModeEnabled, () => {
            this.gameRoomService.setDebugMode(true);
            this.gameManagerService.clearPaths();
            this.gameManagerService.setActionPoints(1);
            if (this.socket.id === this.gameManagerService.currentPlayerId) {
                this.addToJournal({
                    type: 'TOUS',
                    content: `Mode deboggage activé par ${this.gameManagerService.getPlayerById(this.socket.id)?.name} !`,
                });
            }
        });

        this.socket.on(GameRoomEvents.DebugModeDisabled, () => {
            this.gameRoomService.setDebugMode(false);

            this.movementSocketService.getPlayerMovements();
            if (this.socket.id === this.gameManagerService.currentPlayerId) {
                this.addToJournal({
                    type: 'TOUS',
                    content: `Mode deboggage désactivé par ${this.gameManagerService.getPlayerById(this.socket.id)?.name} !`,
                });
            }
        });

        this.socket.on(GameRoomEvents.DoorToggled, (coords) => {
            const door = this.gameManagerService.getBoard().getCell(coords.x, coords.y);
            if (door?.tile.type === 'door') {
                door.tile.toggleState();
                if (this.socket.id === this.gameManagerService.currentPlayerId) {
                    this.addToJournal({
                        type: 'TOUS',
                        content: `La porte (${coords.x}, ${coords.y}) a été ${
                            door?.tile.state === 'opened' ? 'ouverte' : 'fermee'
                        } par ${this.gameManagerService.getPlayerById(this.socket.id)?.name} !`,
                    });
                }
            }
            this.movementSocketService.getPlayerMovements();
            if (this.gameManagerService.isDebugMode) this.gameManagerService.clearPaths();

            if (this.socket.id === this.gameManagerService.currentPlayerId) {
                const player = this.gameManagerService.getMainPlayer();

                if (player && player.movementPoints <= 0 && player.actionPoints <= 0) {
                    const gameRoomId = this.gameManagerService.getRoomId();
                    this.socketService.endPlayerTurn(gameRoomId);
                }
            }
        });
    }
}

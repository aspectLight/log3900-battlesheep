import { Injectable } from '@angular/core';
import { AttackPayload, AttackResult, CombatPayload, FlightResult } from '@app/interfaces/payload.interface';
import { ISocketService } from '@app/interfaces/socket-service.interface';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { CombatService } from '@app/services/gameplay/combat.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { GameRoomService } from '@app/services/state/game-room.service';
import { GameRoomEvents } from '@common/socket.constants';
import { Socket } from 'socket.io-client';
import { MovementSocketService } from './movement-socket.service';
import { NOTIFICATION_DURATION } from '@app/constants/combat.constants';
@Injectable({
    providedIn: 'root',
})
export class ActionSocketService implements ISocketService {
    socket: Socket;

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
        this.setUpListeners();
    }

    toggleDebugMode(): void {
        const room = this.gameManagerService.room;
        if (this.gameManagerService.currentPlayerId === this.socket.id && room.hostId === this.socket.id) {
            this.socket.emit(GameRoomEvents.ToggleDebugMode, room.roomId);
        }
    }

    startCombat(combatPayload: CombatPayload) {
        this.socket.emit(GameRoomEvents.StartCombat, combatPayload, (ack: { success: boolean; error?: string }) => {
            if (!ack?.success) {
                return;
            }
        });
    }

    flightAttempt(combatPayload: CombatPayload) {
        this.socket.emit(GameRoomEvents.FlightAttempt, combatPayload.roomId, (ack: { success: boolean; error?: string }) => {
            if (!ack?.success) {
                return;
            }
        });
    }

    attack(attackPayload: AttackPayload) {
        this.socket.emit(GameRoomEvents.Attack, attackPayload, (ack: { success: boolean; error?: string }) => {
            if (!ack?.success) {
                return;
            }
        });
    }

    toggleDoor(x: number, y: number) {
        const roomId = this.gameManagerService.room.roomId;
        this.socket.emit(GameRoomEvents.DoorToggled, { roomId, x, y });
    }

    endPlayerTurn(): void {
        const roomId = this.gameManagerService.room.roomId;
        this.socketService.endPlayerTurn(roomId);
    }

    private setUpListeners(): void {
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

        this.socket.on(GameRoomEvents.EndCombat, (winnerId, loserId, isByFlight) => {
            const localId = this.socketService.getId();
            const isInvolved = localId === winnerId || localId === loserId;

            if (isByFlight) {
                if (isInvolved) {
                    this.combatService.flightAttemptsLeft = 2;
                    setTimeout(() => {
                        this.combatService.resetCombat();
                    }, NOTIFICATION_DURATION);
                }
                return;
            }

            if (isInvolved) {
                this.combatService.handleEnd(winnerId, loserId);
            } else {
                this.gameManagerService.combatLost(loserId);
            }

            const loser = this.gameManagerService.room.players.find((p) => p.id === loserId);
            const hostId = this.gameManagerService.room.hostId;
            if (this.socket.id === this.combatService.loserId || (loser?.isVirtual && this.socket.id === hostId)) {
                if (loser) {
                    this.movementSocketService.teleportPlayer(loser.spawnPoint.x, loser.spawnPoint.y, { playerId: loser.id });
                }
                this.combatService.loserId = '';
            }
        });

        this.socket.on(GameRoomEvents.DebugModeEnabled, () => {
            this.gameRoomService.setDebugMode(true);
            this.gameManagerService.clearPaths();
            const actionPoints = this.gameManagerService.getGame()?.actionPoints ?? 1;
            this.gameManagerService.setActionPoints(actionPoints);
        });

        this.socket.on(GameRoomEvents.DebugModeDisabled, () => {
            this.gameRoomService.setDebugMode(false);

            this.movementSocketService.getPlayerMovements();
        });

        this.socket.on(GameRoomEvents.DoorToggled, (coords) => {
            const door = this.gameManagerService.getBoard().getCell(coords.x, coords.y);
            if (door?.tile.type === 'door') {
                door.tile.toggleState();
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

/* eslint-disable max-lines */
import { AuthService } from '@app/modules/auth/services/auth.service';
import { Coords } from '@app/modules/movement/interfaces/coords';
import { Item } from '@app/shared/interfaces/item';
import { Player } from '@app/shared/interfaces/player';
import { GameRoomEvents } from '@common/socket.constants';
import { Injectable, Logger } from '@nestjs/common';
import {
    ConnectedSocket,
    MessageBody,
    OnGatewayConnection,
    OnGatewayDisconnect,
    SubscribeMessage,
    WebSocketGateway,
    WebSocketServer,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { ChatHandler } from './handlers/chat.handler';
import { CombatHandler } from './handlers/combat.handler';
import { GameLifecycleHandler } from './handlers/game-lifecycle.handler';
import { ItemsHandler } from './handlers/items.handler';
import { MovementHandler } from './handlers/movement.handler';
import { PlayerConnectionHandler } from './handlers/player-connection.handler';
import { StatisticsHandler } from './handlers/statistics.handler';
import { TrapHandler } from './handlers/trap.handler';
import { TurnHandler } from './handlers/turn.handler';
import { VirtualPlayerHandler } from './handlers/virtual-player.handler';
/**
 * Gateway for game room WebSocket events
 * Acts as a pure event router - all business logic delegated to handlers
 */
@WebSocketGateway({ cors: { origin: '*' } })
@Injectable()
export class GameRoomGateway implements OnGatewayConnection, OnGatewayDisconnect {
    @WebSocketServer() private server: Server;
    private readonly logger = new Logger(GameRoomGateway.name);

    // eslint-disable-next-line max-params
    constructor(
        private readonly authService: AuthService,
        private readonly movementHandler: MovementHandler,
        private readonly combatHandler: CombatHandler,
        private readonly itemsHandler: ItemsHandler,
        private readonly virtualPlayerHandler: VirtualPlayerHandler,
        private readonly gameLifecycleHandler: GameLifecycleHandler,
        private readonly turnHandler: TurnHandler,
        private readonly trapHandler: TrapHandler,
        private readonly chatHandler: ChatHandler,
        private readonly statisticsHandler: StatisticsHandler,
        private readonly playerConnectionHandler: PlayerConnectionHandler,
    ) {}

    // ===== Game Lifecycle Events =====

    @SubscribeMessage(GameRoomEvents.PlayGame)
    async handlePlayGame(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.gameLifecycleHandler.handlePlayGame(roomId, socket, this.server);
    }

    @SubscribeMessage(GameRoomEvents.FinishGame)
    async handleFinishGame(@MessageBody() data: { roomId: string; winnerId: string }, @ConnectedSocket() socket: Socket) {
        return this.gameLifecycleHandler.handleFinishGame(data, socket, this.server);
    }

    @SubscribeMessage(GameRoomEvents.QuitEndGame)
    async handleLeaveEndGame(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.gameLifecycleHandler.handleLeaveEndGame(roomId, socket, this.server);
    }

    @SubscribeMessage(GameRoomEvents.ToggleDebugMode)
    handleToggleDebugMode(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.gameLifecycleHandler.handleToggleDebugMode(roomId, socket, this.server);
    }

    // ===== Player Connection Events =====

    @SubscribeMessage(GameRoomEvents.AbandonGame)
    handleLeaveRoom(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.playerConnectionHandler.handleLeaveRoom(roomId, socket, this.server);
    }

    @SubscribeMessage(GameRoomEvents.JoinGameRoom)
    async handleJoinGameRoom(@MessageBody() data: { roomId: string; player: Player }, @ConnectedSocket() socket: Socket) {
        return this.playerConnectionHandler.handleJoinGameRoom(data, socket, this.server);
    }

    // ===== Turn Management Events =====

    @SubscribeMessage(GameRoomEvents.EndTurn)
    handleEndTurn(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.turnHandler.handleEndTurn(roomId, socket);
    }

    // ===== Chat Events =====

    @SubscribeMessage(GameRoomEvents.SendMessageToGameRoom)
    async handleSendMessage(@MessageBody() data: { message: string; playerName: string | null; roomId: string }, @ConnectedSocket() socket: Socket) {
        return this.chatHandler.handleSendMessage(data, socket, this.server);
    }

    // ===== Statistics Events =====

    @SubscribeMessage(GameRoomEvents.GetStatistics)
    async handleGetStatistics(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.statisticsHandler.handleGetStatistics(roomId, socket);
    }

    // ===== Movement Events =====

    @SubscribeMessage(GameRoomEvents.PlayerGetMovements)
    async handlePlayerGetMovements(
        @MessageBody() data: { roomId: string; hasBoots: boolean },
        @ConnectedSocket() socket: Socket,
    ): Promise<{ success: boolean; paths?: [Coords, Coords[]][]; error?: string }> {
        return this.movementHandler.handlePlayerGetMovements(data, socket);
    }

    @SubscribeMessage(GameRoomEvents.PlayerMoved)
    async handlePlayerMoved(
        @MessageBody() data: { roomId: string; playerId: string; selectedPath: Coords[] },
        @ConnectedSocket() socket: Socket,
    ): Promise<{ success: boolean; error?: string; movementPoints?: number }> {
        return this.movementHandler.handlePlayerMoved(data, this.server, socket);
    }

    @SubscribeMessage(GameRoomEvents.PlayerTeleported)
    async handlePlayerTeleported(
        @MessageBody() data: { roomId: string; playerId: string; destination: Coords; hasCamouflage?: boolean },
    ): Promise<{ success: boolean; error?: string }> {
        return this.movementHandler.handlePlayerTeleported(data, this.server);
    }

    @SubscribeMessage(GameRoomEvents.DoorToggled)
    handleDoorToggled(@MessageBody() data: { roomId: string; x: number; y: number }, @ConnectedSocket() socket: Socket) {
        return this.movementHandler.handleDoorToggled(data, socket, this.server);
    }

    @SubscribeMessage(GameRoomEvents.SynchronizeMovement)
    handleSynchronizeMovement(@MessageBody() data: { roomId: string; playerId: string; destination: Coords }, @ConnectedSocket() socket: Socket) {
        return this.movementHandler.handleSynchronizeMovement(data, socket, this.server);
    }

    // ===== Trap Events =====

    @SubscribeMessage(GameRoomEvents.TrapChoice)
    handleTrapChoice(@MessageBody() data: { roomId: string; playerId: string; choice: 'avoid' | 'traverse' }): { success: boolean; error?: string } {
        return this.trapHandler.handleTrapChoice(data, this.server);
    }

    // ===== Combat Events =====

    @SubscribeMessage(GameRoomEvents.StartCombat)
    handleStartFight(@MessageBody() data: { roomId: string; opponentId: string, isPlayerOnIce: boolean, isOpponentOnIce: boolean }, @ConnectedSocket() socket: Socket) {
        return this.combatHandler.handleStartFight(data, socket, this.server);
    }

    @SubscribeMessage(GameRoomEvents.Attack)
    async handleAttack(@MessageBody() data: { roomId: string }, @ConnectedSocket() socket: Socket) {
        return this.combatHandler.handleAttack(data, socket);
    }

    @SubscribeMessage(GameRoomEvents.FlightAttempt)
    async handleFlightAttempt(@MessageBody() roomId: string, @ConnectedSocket() socket: Socket) {
        return this.combatHandler.handleFlightAttempt(roomId, socket);
    }

    @SubscribeMessage(GameRoomEvents.StartVirtualCombat)
    handleStartVirtualCombat(@MessageBody() data: { roomId: string; playerId: string; opponentId: string }, @ConnectedSocket() socket: Socket) {
        return this.combatHandler.handleStartVirtualCombat(data, socket, this.server);
    }

    // ===== Item Events =====

    @SubscribeMessage(GameRoomEvents.ItemCollected)
    handleItemCollected(@MessageBody() data: { roomId: string; playerId: string; item: Item; position: Coords }, @ConnectedSocket() socket: Socket) {
        return this.itemsHandler.handleItemCollected(data, socket, this.server);
    }

    @SubscribeMessage(GameRoomEvents.ItemDropped)
    handleItemDropped(@MessageBody() data: { roomId: string; playerId: string; item: Item; coords: Coords }, @ConnectedSocket() socket: Socket) {
        return this.itemsHandler.handleItemDropped(data, socket, this.server);
    }

    // ===== Virtual Player Events =====

    @SubscribeMessage(GameRoomEvents.VirtualPlayerTurn)
    handleVirtualPlayerTurn(
        @MessageBody() data: { roomId: string; playerId: string; isCTF: boolean; skipTimeout: boolean },
        @ConnectedSocket() socket: Socket,
    ) {
        return this.virtualPlayerHandler.handleVirtualPlayerTurn(data, socket, this.server);
    }

    // ===== WebSocket Lifecycle Events =====

    async handleConnection(@ConnectedSocket() socket: Socket) {
        try {
            const { token, sessionId } = socket.handshake.auth as { token?: string; sessionId?: string };

            if (!token || !sessionId) {
                this.logger.warn(`Socket ${socket.id} missing token/sessionId`);
                return;
            }

            const decoded = await this.authService.verifyToken(token);
            const ok = await this.authService.validateSession(decoded.uid, sessionId);

            if (!ok) {
                this.logger.warn(`Socket ${socket.id} invalid session for uid=${decoded.uid}`);
                return;
            }

            socket.data.uid = decoded.uid;
            socket.data.sessionId = sessionId;

            this.logger.log(`socket connecté: ${socket.id} uid=${decoded.uid}`);
        } catch (e) {
            this.logger.warn(`Socket ${socket.id} auth failed`);
        }
    }

    handleDisconnect(@ConnectedSocket() socket: Socket) {
        this.playerConnectionHandler.handleDisconnect(socket, this.server);
    }
}

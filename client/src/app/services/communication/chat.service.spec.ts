import { provideHttpClientTesting } from '@angular/common/http/testing';
import { TestBed } from '@angular/core/testing';
import { Player } from '@app/classes/entity/player';
import { SocketService } from '@app/services/communication/socket-handlers/socket.service';
import { RoomSocketService } from '@app/services/communication/socket-handlers/room-socket.service';
import { ChatService } from '@app/services/communication/chat.service';
import { GameManagerService } from '@app/services/state/game-manager.service';
import { WaitingRoomService } from '@app/services/lobby/waiting-room.service';

describe('ChatService', () => {
    let service: ChatService;
    let socketServiceMock: jasmine.SpyObj<SocketService>;
    let roomSocketServiceMock: jasmine.SpyObj<RoomSocketService>;
    let gameManagerServiceMock: jasmine.SpyObj<GameManagerService>;
    let waitingRoomServiceMock: jasmine.SpyObj<WaitingRoomService>;
    // eslint-disable-next-line @typescript-eslint/ban-types
    const eventHandlers: { [key: string]: Function } = {};

    beforeEach(() => {
        socketServiceMock = jasmine.createSpyObj('SocketService', [
            'connect',
            'on',
            'emit',
            'disconnect',
            'getMessagesFromWaitingRoom',
            'getMessagesFromGameRoom',
            'sendMessageToWaitingRoom',
            'sendMessageToGameRoom',
            'getRoomId',
            'registerSocketService',
        ]);
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        (socketServiceMock as any).socket = {
            on: jasmine.createSpy('on'),
            emit: jasmine.createSpy('emit'),
            off: jasmine.createSpy('off'),
            disconnect: jasmine.createSpy('disconnect'),
        };

        socketServiceMock.getRoomId.and.returnValue('roomId');
        socketServiceMock.registerSocketService.and.stub();

        roomSocketServiceMock = jasmine.createSpyObj('RoomSocketService', [
            'getMessagesFromWaitingRoom',
            'sendMessageToWaitingRoom',
            'sendMessageToGameRoom',
            'getId',
        ]);
        roomSocketServiceMock.getId.and.stub();

        gameManagerServiceMock = jasmine.createSpyObj('WaitingRoomService', ['getMainPlayer']);
        gameManagerServiceMock.getMainPlayer.and.returnValue({ name: 'TestUser' } as Player);

        // eslint-disable-next-line @typescript-eslint/ban-types
        socketServiceMock.on.and.callFake((event: string, callback: Function) => {
            eventHandlers[event] = callback;
        });

        waitingRoomServiceMock = jasmine.createSpyObj('WaitingRoomService', ['getPlayerFromId']);

        waitingRoomServiceMock.getPlayerFromId.and.returnValue({ name: 'TestUser' } as Player);

        TestBed.configureTestingModule({
            providers: [
                ChatService,
                provideHttpClientTesting(),
                { provide: SocketService, useValue: socketServiceMock },
                { provide: GameManagerService, useValue: gameManagerServiceMock },
                { provide: RoomSocketService, useValue: roomSocketServiceMock },
                { provide: WaitingRoomService, useValue: waitingRoomServiceMock },
            ],
        });

        service = TestBed.inject(ChatService);
        service.playerName = 'TestUser';
    });

    it('should be created', () => {
        expect(service).toBeTruthy();
    });

    it('should get the name from socketService', () => {
        expect(service.playerName).toBe('TestUser');
    });

    it('should listen to "massMessage" and add message to messages array', () => {
        const testMessage = { type: 'info', content: 'Test message', time: '12:00' };

        eventHandlers['massMessage'](testMessage);

        expect(service.messages).toContain(testMessage);
    });

    it('should listen to "getMessagesResponse" and replace messages array', () => {
        const testMessages = [{ type: 'info', content: 'Previous message', time: '11:00' }];

        eventHandlers['getMessagesResponse'](testMessages);

        expect(service.messages).toEqual(testMessages);
    });

    it('should call socketService.getMessagesFromWaitingRoom', () => {
        service.getMessagesFromWaitingRoom();
        expect(roomSocketServiceMock.getMessagesFromWaitingRoom).toHaveBeenCalled();
    });

    it('should send message to waiting room and add it to messages', () => {
        const newMessage = 'Hello, world!';
        service.sendMessageToWaitingRoom(newMessage);
        expect(service.messages).toContain({
            type: 'sent',
            name: 'TestUser',
            content: newMessage,
            time: jasmine.any(String),
        });

        expect(roomSocketServiceMock.sendMessageToWaitingRoom).toHaveBeenCalledWith(newMessage, 'TestUser');
    });

    it('should send message to game room and add it to messages', () => {
        const newMessage = 'Hello, world!';
        service.sendMessageToGameRoom(newMessage);

        expect(service.messages).toContain({
            type: 'sent',
            name: 'TestUser',
            content: newMessage,
            time: jasmine.any(String),
        });
        expect(socketServiceMock.sendMessageToGameRoom).toHaveBeenCalledWith(newMessage, 'TestUser');
    });
});

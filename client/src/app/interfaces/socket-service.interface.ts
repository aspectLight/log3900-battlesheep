import { Socket } from 'socket.io-client';

export interface ISocketService {
    socket: Socket;
    setUpConnection(): void;
}

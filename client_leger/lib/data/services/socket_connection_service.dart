import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../domain/interfaces/services/socket_connection_service.dart';
import './log_service.dart';
import './socket_chat_service.dart';

class SocketConnectionServiceImpl implements SocketConnectionService {
  final String serverUrl;
  final SocketChatServiceImpl _chatService;

  io.Socket? _socket;
  String? _currentUsername;

  @override
  bool get isConnected => _chatService.isConnected;

  @override
  String? get currentUsername => _currentUsername;

  SocketConnectionServiceImpl({
    required this.serverUrl,
    required SocketChatServiceImpl chatService,
  }) : _chatService = chatService;

  @override
  void connect(String username) {
    if (isConnected) {
      LogService.i('Already connected, disconnecting first');
      disconnect();
    }

    LogService.i('Initiating connection to chat server as $username');
    _currentUsername = username;

    _socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();

    _chatService.initializeSocket(_socket!);
  }

  @override
  void disconnect() {
    if (!isConnected) return;

    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _currentUsername = null;

    _chatService.clearSocket();

    LogService.i('Disconnected from server');
  }

  @override
  void dispose() {
    disconnect();
    LogService.i('SocketConnectionService disposed');
  }
}

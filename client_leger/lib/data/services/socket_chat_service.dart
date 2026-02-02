import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../domain/interfaces/services/socket_chat_service.dart';
import '../models/chat_socket_events.dart';
import 'log_service.dart';

class SocketChatServiceImpl implements SocketChatService {
  io.Socket? socket;
  bool _isConnected = false;

  final _connectionController = StreamController<bool>.broadcast();
  final _messageReceivedController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _messagesHistoryController =
      StreamController<List<dynamic>>.broadcast();
  final _errorController = StreamController<dynamic>.broadcast();

  @override
  Stream<bool> get connectionStream => _connectionController.stream;

  @override
  Stream<Map<String, dynamic>> get messageReceivedStream =>
      _messageReceivedController.stream;

  @override
  Stream<List<dynamic>> get messagesHistoryStream =>
      _messagesHistoryController.stream;

  @override
  Stream<dynamic> get errorStream => _errorController.stream;

  @override
  bool get isConnected => _isConnected;

  SocketChatServiceImpl();

  void initializeSocket(io.Socket socket) {
    this.socket = socket;
    _setupListeners();
  }

  void updateConnectionStatus(bool status) {
    _isConnected = status;
    _connectionController.add(status);
  }

  void clearSocket() {
    socket = null;
    _isConnected = false;
    _connectionController.add(false);
  }

  void _setupListeners() {
    socket!.on('connect', (_) {
      LogService.i('Connected to chat server');
      _isConnected = true;
      _connectionController.add(true);
    });

    socket!.on('disconnect', (_) {
      LogService.w('Disconnected from chat server');
      _isConnected = false;
      _connectionController.add(false);
    });

    socket!.on('error', (error) {
      LogService.e('Chat socket error', error);
      _errorController.add(error);
    });

    socket!.on(GeneralChatEvents.generalChatMessage, (data) {
      final messageData = data as Map<String, dynamic>;
      LogService.d('Received message from ${messageData['name']}');
      _messageReceivedController.add(messageData);
    });

    socket!.on(GeneralChatEvents.getGeneralChatMessagesResponse, (data) {
      final messageList = data as List<dynamic>;
      LogService.i('Loaded ${messageList.length} chat messages');
      _messagesHistoryController.add(messageList);
    });
  }

  @override
  void getGeneralChatMessages() {
    if (!_isConnected || socket == null) {
      LogService.w('Cannot get messages: not connected');
      return;
    }
    socket!.emit(GeneralChatEvents.getGeneralChatMessages);
    LogService.d('Requesting general chat messages');
  }

  @override
  void sendMessage({required String username, required String message}) {
    if (!_isConnected || socket == null) {
      LogService.w('Cannot send message: not connected');
      return;
    }

    socket!.emit(GeneralChatEvents.sendMessageToGeneralChat, {
      'username': username,
      'message': message,
    });
    LogService.d('Sent message to general chat');
  }

  @override
  Future<void> dispose() async {
    await _connectionController.close();
    await _messageReceivedController.close();
    await _messagesHistoryController.close();
    await _errorController.close();
    LogService.i('SocketChatService disposed');
  }
}

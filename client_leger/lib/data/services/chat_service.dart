import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as io;

import '../models/chat_message_dto.dart';
import '../models/chat_socket_events.dart';

class ChatService {
  final String serverUrl;
  io.Socket? _socket;
  final List<ChatMessageDto> _messages = [];

  final _messagesController =
      StreamController<List<ChatMessageDto>>.broadcast();
  Stream<List<ChatMessageDto>> get messagesStream => _messagesController.stream;

  List<ChatMessageDto> get messages => List.unmodifiable(_messages);

  String? _username;
  bool _isConnected = false;

  ChatService({required this.serverUrl});

  void connect(String username) {
    if (_isConnected && _username == username) {
      return;
    }

    if (_isConnected) {
      disconnect();
    }

    _username = username;

    _socket = io.io(serverUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket!.connect();
    _isConnected = true;
    _setupListeners();
    joinGeneralChat(username);
  }

  void disconnect() {
    if (!_isConnected) return;

    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _username = null;
    clearMessages();
  }

  void _setupListeners() {
    _socket!.on('connect', (_) {
      print('Connected to chat server');
    });

    _socket!.on('disconnect', (_) {
      print('Disconnected from chat server');
      _isConnected = false;
    });

    _socket!.on('error', (error) {
      print('Chat socket error: $error');
    });

    _socket!.on(GeneralChatEvents.generalChatMessage, (data) {
      final messageData = data as Map<String, dynamic>;
      final message = ChatMessageDto(
        type: messageData['type'],
        name: messageData['name'],
        content: messageData['content'],
        time: messageData['time'],
        isMe: messageData['name'] == _username,
      );
      _messages.add(message);
      _messagesController.add(_messages);
    });

    _socket!.on(GeneralChatEvents.getGeneralChatMessagesResponse, (data) {
      _messages.clear();
      final messageList = data as List<dynamic>;
      for (final messageData in messageList) {
        final messageMap = messageData as Map<String, dynamic>;
        final message = ChatMessageDto(
          type: messageMap['type'],
          name: messageMap['name'],
          content: messageMap['content'],
          time: messageMap['time'],
          isMe: messageMap['name'] == _username,
        );
        _messages.add(message);
      }
      _messagesController.add(_messages);
    });
  }

  void joinGeneralChat(String username) {
    if (!_isConnected) return;
    _socket!.emit(GeneralChatEvents.joinGeneralChat, username);
  }

  void getGeneralChatMessages() {
    if (!_isConnected) return;
    _socket!.emit(GeneralChatEvents.getGeneralChatMessages);
  }

  void sendMessageToGeneralChat(String message) {
    if (!_isConnected) return;

    final newMessage = ChatMessageDto(
      type: 'sent',
      name: _username,
      content: message,
      time: _formatTime(DateTime.now()),
      isMe: true,
    );

    _messages.add(newMessage);
    _messagesController.add(_messages);

    _socket!.emit(GeneralChatEvents.sendMessageToGeneralChat, {
      'username': _username,
      'message': message,
    });
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}:'
        '${time.second.toString().padLeft(2, '0')}';
  }

  void clearMessages() {
    _messages.clear();
    _messagesController.add(_messages);
  }

  Future<void> dispose() async {
    disconnect();
    await _messagesController.close();
  }
}

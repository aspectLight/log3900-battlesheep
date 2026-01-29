import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatService {
  final String serverUrl;
  IO.Socket? _socket;
  final List<ChatMessage> _messages = [];

  final _messagesController = StreamController<List<ChatMessage>>.broadcast();
  Stream<List<ChatMessage>> get messagesStream => _messagesController.stream;

  List<ChatMessage> get messages => List.unmodifiable(_messages);

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

    _socket = IO.io(serverUrl, <String, dynamic>{
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
      final message = ChatMessage(
        type: data['type'],
        name: data['name'],
        content: data['content'],
        time: data['time'],
        isMe: data['name'] == _username,
      );
      _messages.add(message);
      _messagesController.add(_messages);
    });

    _socket!.on(GeneralChatEvents.getGeneralChatMessagesResponse, (data) {
      _messages.clear();
      for (final messageData in data) {
        final message = ChatMessage(
          type: messageData['type'],
          name: messageData['name'],
          content: messageData['content'],
          time: messageData['time'],
          isMe: messageData['name'] == _username,
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

    final newMessage = ChatMessage(
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

  void dispose() {
    disconnect();
    _messagesController.close();
  }
}

// Constantes pour les événements Socket.IO
class GeneralChatEvents {
  static const String joinGeneralChat = 'joinGeneralChat';
  static const String getGeneralChatMessages = 'getGeneralChatMessages';
  static const String getGeneralChatMessagesResponse =
      'getGeneralChatMessagesResponse';
  static const String sendMessageToGeneralChat = 'sendMessageToGeneralChat';
  static const String generalChatMessage = 'generalChatMessage';
}

// Modèle de message
class ChatMessage {
  final String type;
  final String? name;
  final String content;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.type,
    this.name,
    required this.content,
    required this.time,
    required this.isMe,
  });
}

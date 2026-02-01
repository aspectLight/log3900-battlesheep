import 'dart:async';

import '../../../core/helpers/formatter.dart';
import '../../../data/models/chat_message_dto.dart';
import '../../../data/services/log_service.dart';
import '../../../data/services/socket_chat_service.dart';

class ChatRepository {
  final SocketChatServiceImpl _socketService;
  final List<ChatMessageDto> _messages = [];
  String? _currentUsername;

  final _messagesController =
      StreamController<List<ChatMessageDto>>.broadcast();
  final _connectionStatusController = StreamController<bool>.broadcast();

  Stream<List<ChatMessageDto>> get messagesStream => _messagesController.stream;
  Stream<bool> get connectionStatusStream => _connectionStatusController.stream;
  List<ChatMessageDto> get messages => List.unmodifiable(_messages);
  bool get isConnected => _socketService.isConnected;
  String? get currentUsername => _currentUsername;

  late final StreamSubscription _messageReceivedSub;
  late final StreamSubscription _messagesHistorySub;
  late final StreamSubscription _connectionSub;
  late final StreamSubscription _errorSub;

  ChatRepository(this._socketService) {
    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    // Écouter les nouveaux messages
    _messageReceivedSub = _socketService.messageReceivedStream.listen((data) {
      final message = ChatMessageDto(
        type: data['type'],
        name: data['name'],
        content: data['content'],
        time: data['time'],
        isMe: data['name'] == _currentUsername,
      );
      _addMessage(message);
    });

    // Écouter l'historique des messages
    _messagesHistorySub = _socketService.messagesHistoryStream.listen((
      messageList,
    ) {
      _messages.clear();
      for (final messageData in messageList) {
        final messageMap = messageData as Map<String, dynamic>;
        final message = ChatMessageDto(
          type: messageMap['type'],
          name: messageMap['name'],
          content: messageMap['content'],
          time: messageMap['time'],
          isMe: messageMap['name'] == _currentUsername,
        );
        _messages.add(message);
      }
      _messagesController.add(_messages);
    });

    // Écouter l'état de la connexion
    _connectionSub = _socketService.connectionStream.listen((isConnected) {
      _connectionStatusController.add(isConnected);
      if (!isConnected) {
        LogService.w('Connection lost, clearing messages');
      }
    });

    // Écouter les erreurs
    _errorSub = _socketService.errorStream.listen((error) {
      LogService.e('Socket error in repository', error);
    });
  }

  void connect(String username) {
    _currentUsername = username;
    _socketService.connect(username);
  }

  void disconnect() {
    _socketService.disconnect();
    _currentUsername = null;
    clearMessages();
  }

  void loadMessages() {
    _socketService.getGeneralChatMessages();
  }

  void sendMessage(String content) {
    if (_currentUsername == null || content.trim().isEmpty) {
      LogService.w('Cannot send message: invalid username or empty content');
      return;
    }

    // Ajouter le message localement immédiatement
    final newMessage = ChatMessageDto(
      type: 'sent',
      name: _currentUsername,
      content: content,
      time: Formatter.formatTime(DateTime.now()),
      isMe: true,
    );
    _addMessage(newMessage);

    // Envoyer au serveur
    _socketService.sendMessage(username: _currentUsername!, message: content);
  }

  void _addMessage(ChatMessageDto message) {
    _messages.add(message);
    _messagesController.add(_messages);
  }

  void clearMessages() {
    _messages.clear();
    _messagesController.add(_messages);
    LogService.d('Cleared all messages');
  }

  Future<void> dispose() async {
    await _messageReceivedSub.cancel();
    await _messagesHistorySub.cancel();
    await _connectionSub.cancel();
    await _errorSub.cancel();
    await _messagesController.close();
    await _connectionStatusController.close();
    await _socketService.dispose();
    LogService.i('ChatRepository disposed');
  }
}

import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../core/helpers/formatter.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/interfaces/repositories/chat_repository.dart';
import '../../domain/interfaces/services/socket_chat_service.dart';
import '../../domain/interfaces/services/socket_connection_service.dart';
import '../models/chat_message_dto.dart';
import '../services/log_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final SocketChatService _chatService;
  final SocketConnectionService _connectionService;

  @override
  final Signal<List<ChatMessageEntity>> messages = signal([]);

  @override
  late final Signal<bool> isConnected;

  @override
  final Signal<String?> currentUsername = signal(null);

  late final StreamSubscription _messageReceivedSub;
  late final StreamSubscription _messagesHistorySub;
  late final StreamSubscription _connectionSub;
  late final StreamSubscription _errorSub;

  ChatRepositoryImpl({
    required SocketChatService chatService,
    required SocketConnectionService connectionService,
  }) : _chatService = chatService,
       _connectionService = connectionService {
    isConnected = signal(_chatService.isConnected);
    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    _messageReceivedSub = _chatService.messageReceivedStream.listen((data) {
      final dto = ChatMessageDto(
        type: data['type'] as String,
        name: data['name'] as String?,
        content: data['content'] as String,
        time: data['time'] as String,
      );
      _addMessage(dto.toEntity());
    });

    _messagesHistorySub = _chatService.messagesHistoryStream.listen((
      messageList,
    ) {
      final newMessages = <ChatMessageEntity>[];
      for (final messageData in messageList) {
        final messageMap = messageData as Map<String, dynamic>;
        final dto = ChatMessageDto(
          type: messageMap['type'] as String,
          name: messageMap['name'] as String?,
          content: messageMap['content'] as String,
          time: messageMap['time'] as String,
        );
        newMessages.add(dto.toEntity());
      }
      messages.value = newMessages;
    });

    _connectionSub = _chatService.connectionStream.listen((connected) {
      isConnected.value = connected;
      if (!connected) {
        LogService.w('Connection lost, clearing messages');
      }
    });

    _errorSub = _chatService.errorStream.listen((error) {
      LogService.e('Socket error in repository', error);
    });
  }

  @override
  void connect(String username) {
    currentUsername.value = username;
    _connectionService.connect(username);
  }

  @override
  void disconnect() {
    _connectionService.disconnect();
    currentUsername.value = null;
    clearMessages();
  }

  @override
  void loadMessages() {
    _chatService.getGeneralChatMessages();
  }

  @override
  void sendMessage(String content) {
    if (currentUsername.value == null || content.trim().isEmpty) {
      LogService.w('Cannot send message: invalid username or empty content');
      return;
    }

    final newEntity = ChatMessageEntity(
      type: 'sent',
      name: currentUsername.value,
      content: content,
      time: Formatter.formatTime(DateTime.now()),
    );
    _addMessage(newEntity);

    _chatService.sendMessage(
      username: currentUsername.value!,
      message: content,
    );
  }

  void _addMessage(ChatMessageEntity message) {
    messages.value = [...messages.value, message];
  }

  @override
  void clearMessages() {
    messages.value = [];
    LogService.d('Cleared all messages');
  }

  @override
  Future<void> dispose() async {
    await _messageReceivedSub.cancel();
    await _messagesHistorySub.cancel();
    await _connectionSub.cancel();
    await _errorSub.cancel();

    messages.dispose();
    isConnected.dispose();
    currentUsername.dispose();

    await _chatService.dispose();
    _connectionService.dispose();

    LogService.i('ChatRepository disposed');
  }
}

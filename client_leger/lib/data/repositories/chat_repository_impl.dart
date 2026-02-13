import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../core/helpers/formatter.dart';
import '../../core/session/user_session.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/interfaces/repositories/chat_repository.dart';
import '../../domain/interfaces/services/socket_service.dart';
import '../models/chat_message_dto.dart';
import '../models/chat_socket_events.dart';
import '../services/log_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final SocketService _socketService;
  final UserSession _userSession;

  @override
  final Signal<List<ChatMessageEntity>> messages = signal([]);

  @override
  final Signal<bool> isConnected = signal(false);

  StreamSubscription? _connectionSub;
  StreamSubscription? _messageSub;
  StreamSubscription? _emojiSub;
  StreamSubscription? _historySub;
  StreamSubscription? _socketErrorSub;

  ChatRepositoryImpl({
    required SocketService socketService,
    required UserSession userSession,
  }) : _socketService = socketService,
       _userSession = userSession {
    _setupConnectionListener();
  }

  void _setupConnectionListener() {
    _connectionSub = _socketService.connectionStream.listen((connected) {
      isConnected.value = connected;
      if (connected) {
        _setupChatListeners();
        final username = _userSession.currentUsername;
        if (username != null) {
          _joinChat(username);
        }
        loadMessages();
      }
    });
    _socketErrorSub = _socketService.errorStream.listen(
      (e) => LogService.e('Socket error', e),
    );
  }

  void _setupChatListeners() {
    _cancelChatSubscriptions();
    _messageSub = _socketService
        .on(GeneralChatEvents.generalChatMessage)
        .listen(_handleMessage);
    _emojiSub = _socketService
        .on(GeneralChatEvents.generalChatEmoji)
        .listen(_handleMessage);
    _historySub = _socketService
        .on(GeneralChatEvents.getGeneralChatMessagesResponse)
        .listen(_handleHistory);
  }

  void _cancelChatSubscriptions() {
    unawaited(_messageSub?.cancel());
    unawaited(_emojiSub?.cancel());
    unawaited(_historySub?.cancel());
  }

  void _handleMessage(dynamic data) {
    final dto = ChatMessageDto.fromSocketData(data as Map<String, dynamic>);
    _addMessage(dto.toEntity());
  }

  void _handleHistory(dynamic data) {
    final list = data as List<dynamic>;
    messages.value = list
        .map(
          (item) => ChatMessageDto.fromSocketData(
            item as Map<String, dynamic>,
          ).toEntity(),
        )
        .toList();
    LogService.i('Loaded ${messages.value.length} messages');
  }

  void _joinChat(String username) {
    if (!_socketService.isConnected) return;
    _socketService.emit(GeneralChatEvents.joinGeneralChat, username);
    LogService.i('Joined general chat as $username');
  }

  @override
  void loadMessages() {
    if (!_socketService.isConnected) {
      LogService.w('Cannot load messages: not connected');
      return;
    }
    LogService.d('Emitted event: ${GeneralChatEvents.getGeneralChatMessages}');
    _socketService.emit(GeneralChatEvents.getGeneralChatMessages);
  }

  @override
  void sendMessage({required String username, required String content}) {
    if (content.trim().isEmpty) return;
    _socketService.emit(GeneralChatEvents.sendMessageToGeneralChat, {
      'username': username,
      'message': content,
    });
  }

  @override
  void sendEmoji({required String username, required String emoji}) {
    final optimisticEntity = ChatMessageEntity(
      type: 'emoji-sent',
      name: username,
      content: emoji,
      time: Formatter.formatTime(DateTime.now()),
    );
    _addMessage(optimisticEntity);
    _socketService.emit(GeneralChatEvents.sendEmojiToGeneralChat, {
      'username': username,
      'emoji': emoji,
    });
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
    await _connectionSub?.cancel();
    await _messageSub?.cancel();
    await _emojiSub?.cancel();
    await _historySub?.cancel();
    await _socketErrorSub?.cancel();
    messages.dispose();
    isConnected.dispose();
    LogService.i('ChatRepository disposed');
  }
}

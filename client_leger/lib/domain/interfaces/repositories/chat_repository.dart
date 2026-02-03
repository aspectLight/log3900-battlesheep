import 'package:signals_flutter/signals_flutter.dart';

import '../../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Signal<List<ChatMessageEntity>> get messages;
  Signal<bool> get isConnected;
  Signal<String?> get currentUsername;

  void connect(String username);
  void disconnect();

  void loadMessages();
  void sendMessage(String content);
  void sendEmoji(String emoji);
  void clearMessages();

  Future<void> dispose();
}

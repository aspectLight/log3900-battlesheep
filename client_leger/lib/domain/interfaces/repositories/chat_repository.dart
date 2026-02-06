import 'package:signals_flutter/signals_flutter.dart';

import '../../entities/chat_message_entity.dart';

abstract class ChatRepository {
  Signal<List<ChatMessageEntity>> get messages;
  Signal<bool> get isConnected;

  void sendMessage({required String username, required String content});
  void sendEmoji({required String username, required String emoji});
  void loadMessages();
  void clearMessages();
  Future<void> dispose();
}

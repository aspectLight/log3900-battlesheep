import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/chat_message_entity.dart';
import '../../domain/interfaces/repositories/chat_repository.dart';

class ChatViewModel {
  final ChatRepository _repository;

  ChatViewModel(this._repository);

  Signal<List<ChatMessageEntity>> get messages => _repository.messages;
  Signal<bool> get isConnected => _repository.isConnected;
  Signal<String?> get currentUsername => _repository.currentUsername;

  void loadMessages() {
    _repository.loadMessages();
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;
    _repository.sendMessage(content);
  }

  void clearMessages() {
    _repository.clearMessages();
  }

  void dispose() {
    // Le repository sera disposé par le container d'injection de dépendances
  }
}

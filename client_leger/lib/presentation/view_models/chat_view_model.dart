import 'package:signals_flutter/signals_flutter.dart';

import '../../data/models/ui_chat_message.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/interfaces/repositories/chat_repository.dart';

class ChatViewModel {
  final ChatRepository _repository;

  ChatViewModel(this._repository);

  Signal<List<ChatMessageEntity>> get _messages => _repository.messages;
  Signal<bool> get isConnected => _repository.isConnected;
  Signal<String?> get _currentUsername => _repository.currentUsername;

  late final Computed<List<UiChatMessage>> messages = computed(() {
    final currentUsername = _currentUsername.value;
    return _messages.value
        .map((entity) => UiChatMessage.fromEntity(entity, currentUsername))
        .toList();
  });

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

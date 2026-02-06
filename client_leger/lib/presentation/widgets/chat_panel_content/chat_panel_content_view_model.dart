import 'package:signals_flutter/signals_flutter.dart';
import '../../../core/session/user_session.dart';
import '../../../domain/entities/chat_message_entity.dart';
import '../../../domain/interfaces/repositories/chat_repository.dart';
import '../../ui_models/chat_ui_message.dart';

class ChatPanelContentViewModel {
  final ChatRepository _repository;
  final UserSession _userSession;

  ChatPanelContentViewModel({
    required ChatRepository repository,
    required UserSession userSession,
  }) : _repository = repository,
       _userSession = userSession;

  Signal<List<ChatMessageEntity>> get messages => _repository.messages;
  Signal<bool> get isConnected => _repository.isConnected;

  final Signal<String?> lastSentMessage = signal(null);

  String? get _currentUsername => _userSession.currentUsername;

  late final uiMessages = computed(() {
    final username = _currentUsername ?? '';
    return messages.value
        .map((e) => ChatUiMessage.fromEntity(e, currentUsername: username))
        .toList();
  });

  void loadMessages() {
    _repository.loadMessages();
  }

  void sendMessage(String content) {
    if (_currentUsername == null || content.trim().isEmpty) return;
    _repository.sendMessage(username: _currentUsername!, content: content);
    lastSentMessage.value = content;
  }

  void clearMessages() {
    _repository.clearMessages();
  }

  void sendEmoji(String emoji) {
    if (_currentUsername == null) return;
    _repository.sendEmoji(username: _currentUsername!, emoji: emoji);
  }

  void resendLastMessage() {
    final lastMessage = lastSentMessage.value;
    if (lastMessage != null) {
      sendMessage(lastMessage);
    }
  }

  void dispose() {}
}

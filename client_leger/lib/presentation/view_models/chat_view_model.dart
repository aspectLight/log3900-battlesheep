import 'package:flutter/foundation.dart';

import '../../data/models/chat_message_dto.dart';
import '../../domain/interfaces/repositories/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository;

  ChatViewModel(this._repository);

  Stream<List<ChatMessageDto>> get messagesStream => _repository.messagesStream;
  Stream<bool> get connectionStatusStream => _repository.connectionStatusStream;
  List<ChatMessageDto> get messages => _repository.messages;
  bool get isConnected => _repository.isConnected;
  String? get currentUsername => _repository.currentUsername;

  void loadMessages() {
    _repository.loadMessages();
  }

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;
    _repository.sendMessage(content);
  }

  void clearMessages() {
    _repository.clearMessages();
    notifyListeners();
  }

  @override
  void dispose() {
    // Ne pas disposer le repository ici car il peut être partagé
    super.dispose();
  }
}

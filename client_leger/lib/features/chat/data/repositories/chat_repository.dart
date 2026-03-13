import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/commands/chat_commands.dart';
import '../../domain/events/chat_events.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/state/chat_state.dart';
import '../reducers/chat_state_reducer.dart';
import '../services/chat_socket.dart';

class ChatRepository {
  final ChatSocket _chatSocket;
  final ChatStateReducer _reducer;

  final Signal<ChatState> state = signal(ChatState.initial());

  ChatRepository({
    required ChatSocket chatSocket,
    required ChatStateReducer reducer,
  }) : _chatSocket = chatSocket,
       _reducer = reducer;

  void loadMessages() {
    _chatSocket.loadMessages();
  }

  void sendMessage(SendChatMessageCommand command) {
    if (command.content.trim().isEmpty) return;
    _chatSocket.sendMessage(command);
  }

  void sendEmoji(SendChatEmojiCommand command) {
    _chatSocket.sendEmoji(command);
  }

  void applyMessageAdded(ChatMessage message) {
    state.value = _reducer.reduce(state.value, ChatMessageAddedEvent(message));
  }

  void applyHistorySet(List<ChatMessage> messages) {
    state.value = _reducer.reduce(state.value, ChatHistorySetEvent(messages));
  }
}

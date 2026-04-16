import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/config/env_config.dart';
import '../../../authentication/core/interfaces/auth_repository.dart';
import '../../domain/commands/chat_commands.dart';
import '../../domain/events/chat_events.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/state/chat_state.dart';
import '../reducers/chat_state_reducer.dart';
import '../services/chat_socket.dart';

class ChatRepository {
  final ChatSocket _chatSocket;
  final ChatStateReducer _reducer;
  final AuthRepository _authRepository;

  final Signal<ChatState> state = signal(ChatState.initial());

  ChatRepository({
    required ChatSocket chatSocket,
    required ChatStateReducer reducer,
    required AuthRepository authRepository,
  }) : _chatSocket = chatSocket,
       _reducer = reducer,
       _authRepository = authRepository;

  void loadMessages() {
    _chatSocket.loadMessages();
  }

  void sendMessage(SendChatMessageCommand command) {
    if (command.content.trim().isEmpty) return;
    unawaited(_sendMessageWithProfileAvatars(command));
  }

  Future<void> _sendMessageWithProfileAvatars(
    SendChatMessageCommand command,
  ) async {
    final userResult = await _authRepository.getCurrentUser().run();
    final enriched = switch (userResult) {
      Right(value: final opt) => opt.match(
        () => command,
        (user) => command.copyWith(
          avatarId: user.avatarId,
          avatarUrl: EnvConfig.absoluteProfileAvatarUrlForChatSocket(
            user.avatarUrl,
          ),
        ),
      ),
      Left() => command,
    };
    _chatSocket.sendMessage(enriched);
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

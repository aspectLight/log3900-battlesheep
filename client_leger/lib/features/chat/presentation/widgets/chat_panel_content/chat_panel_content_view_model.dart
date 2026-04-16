import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/chat/chat_avatar_registry.dart';
import '../../../../../core/chat/chat_outgoing_avatars.dart';
import '../../../../../core/helpers/functional_programming.dart';
import '../../../core/constants/chat_constants.dart';
import '../../../data/repositories/chat_panel_state_repository.dart';
import '../../../data/repositories/chat_repository.dart';
import '../../../domain/commands/chat_commands.dart';
import '../../mappers/chat_message_ui_mapper.dart';

class ChatPanelContentViewModel {
  ChatPanelContentViewModel({
    required ChatRepository repository,
    required ChatPanelStateRepository panelStateRepository,
    required ChatOutgoingAvatars outgoingAvatars,
    required ChatAvatarRegistry avatarRegistry,
    required this.currentUsername,
  }) : _repository = repository,
       _panelStateRepository = panelStateRepository,
       _outgoingAvatars = outgoingAvatars,
       _avatarRegistry = avatarRegistry;

  final ChatRepository _repository;
  final ChatPanelStateRepository _panelStateRepository;
  final ChatOutgoingAvatars _outgoingAvatars;
  final ChatAvatarRegistry _avatarRegistry;
  final String currentUsername;

  late final lastSentMessage = computed<Option<String>>(
    () => _panelStateRepository.lastSentMessage.value,
  );
  late final selectedEmojiIndex = computed<int>(
    () => _panelStateRepository.selectedEmojiIndex.value,
  );

  List<String> get defaultEmojis => ChatConstants.defaultEmojis;

  late final uiMessages = computed(() {
    _avatarRegistry.entries.value;
    final chatState = _repository.state.value;
    _avatarRegistry.ensureLoaded(chatState.messages.map((e) => e.name));
    return chatState.messages
        .map((e) {
          final resolved = _avatarRegistry.resolveForAuthor(
            e.name,
            messageAvatarId: e.avatarId,
            messageAvatarUrl: e.avatarUrl,
          );
          return toChatMessageUi(
            e,
            currentUsername: currentUsername,
            displayAvatarId: resolved.avatarId,
            displayAvatarUrl: resolved.avatarUrl,
            avatarDisplayNonce: resolved.avatarDisplayNonce,
          );
        })
        .toList();
  });

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;
    final command = SendChatMessageCommand(
      username: currentUsername,
      content: content,
      avatarId: _outgoingAvatars.avatarId,
      avatarUrl: _outgoingAvatars.avatarUrlForSocket,
    );
    _repository.sendMessage(command);
    _panelStateRepository.setLastSentMessage(Option.of(content));
  }

  void sendEmoji(String emoji) {
    final command = SendChatEmojiCommand(
      username: currentUsername,
      emoji: emoji,
    );
    _repository.sendEmoji(command);
  }

  void resendLastMessage() {
    lastSentMessage.value.whenPresent(sendMessage);
  }

  void selectEmoji(int index) {
    _panelStateRepository.setSelectedEmojiIndex(index);
  }

  void dispose() {}
}

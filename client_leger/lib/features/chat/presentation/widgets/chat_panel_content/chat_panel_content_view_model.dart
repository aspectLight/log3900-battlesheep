import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

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
    required this.currentUsername,
  }) : _repository = repository,
       _panelStateRepository = panelStateRepository;

  final ChatRepository _repository;
  final ChatPanelStateRepository _panelStateRepository;
  final String currentUsername;

  late final lastSentMessage = computed<Option<String>>(
    () => _panelStateRepository.lastSentMessage.value,
  );
  late final selectedEmojiIndex = computed<int>(
    () => _panelStateRepository.selectedEmojiIndex.value,
  );

  List<String> get defaultEmojis => ChatConstants.defaultEmojis;

  late final uiMessages = computed(() {
    final chatState = _repository.state.value;
    return chatState.messages
        .map((e) => toChatMessageUi(e, currentUsername: currentUsername))
        .toList();
  });

  void sendMessage(String content) {
    if (content.trim().isEmpty) return;
    final command = SendChatMessageCommand(
      username: currentUsername,
      content: content,
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

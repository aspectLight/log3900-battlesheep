import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/constants/chat_constants.dart';
import '../../core/event_bus/chat_event_bus.dart';
import '../../domain/commands/chat_commands.dart';
import '../repositories/chat_panel_state_repository.dart';
import '../repositories/chat_repository.dart';

class ChatShakeSideEffect with DisposableSideEffect {
  final String _username;
  final ChatEventBus _chatEventBus;
  final ChatRepository _chatRepository;
  final ChatPanelStateRepository _panelStateRepository;

  ChatShakeSideEffect({
    required String username,
    required ChatEventBus chatEventBus,
    required ChatRepository chatRepository,
    required ChatPanelStateRepository panelStateRepository,
  }) : _username = username,
       _chatEventBus = chatEventBus,
       _chatRepository = chatRepository,
       _panelStateRepository = panelStateRepository {
    trackSubscription(
      _chatEventBus.on<ChatVerticalShakeDetected>().listen(_onVerticalShake),
    );
    trackSubscription(
      _chatEventBus.on<ChatHorizontalShakeDetected>().listen(_onHorizontalShake),
    );
  }

  void _onVerticalShake(ChatVerticalShakeDetected event) {
    _panelStateRepository.lastSentMessage.value.whenPresent((content) {
      _chatRepository.sendMessage(
        SendChatMessageCommand(username: _username, content: content),
      );
    });
  }

  void _onHorizontalShake(ChatHorizontalShakeDetected event) {
    final index = _panelStateRepository.selectedEmojiIndex.value;
    if (index >= 0 && index < ChatConstants.defaultEmojis.length) {
      _chatRepository.sendEmoji(
        SendChatEmojiCommand(
          username: _username,
          emoji: ChatConstants.defaultEmojis[index],
        ),
      );
    }
  }
}

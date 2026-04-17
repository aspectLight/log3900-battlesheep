import '../../../../core/chat/chat_outgoing_avatars.dart';
import '../../../../core/helpers/functional_programming.dart';
import '../../../../core/interfaces/disposable_side_effect.dart';
import '../../core/constants/chat_constants.dart';
import '../../core/event_bus/chat_event_bus.dart';
import '../../domain/commands/chat_commands.dart';
import '../repositories/chat_panel_state_repository.dart';
import '../repositories/chat_repository.dart';
import '../repositories/discussion_canals_repository.dart';

class ChatShakeSideEffect with DisposableSideEffect {
  final String _username;
  final ChatEventBus _chatEventBus;
  final ChatRepository _chatRepository;
  final ChatPanelStateRepository _panelStateRepository;
  final DiscussionCanalsRepository _canalsRepository;
  final ChatOutgoingAvatars _outgoingAvatars;

  ChatShakeSideEffect({
    required String username,
    required ChatEventBus chatEventBus,
    required ChatRepository chatRepository,
    required ChatPanelStateRepository panelStateRepository,
    required DiscussionCanalsRepository canalsRepository,
    required ChatOutgoingAvatars outgoingAvatars,
  }) : _username = username,
       _chatEventBus = chatEventBus,
       _chatRepository = chatRepository,
       _panelStateRepository = panelStateRepository,
       _canalsRepository = canalsRepository,
       _outgoingAvatars = outgoingAvatars {
    trackSubscription(
      _chatEventBus.on<ChatVerticalShakeDetected>().listen(_onVerticalShake),
    );
    trackSubscription(
      _chatEventBus.on<ChatHorizontalShakeDetected>().listen(
        _onHorizontalShake,
      ),
    );
  }

  void _onVerticalShake(ChatVerticalShakeDetected event) {
    _panelStateRepository.lastSentMessage.value.whenPresent((content) {
      final customId = _panelStateRepository.activeCustomChannelId.value;
      if (customId != null) {
        _canalsRepository.sendMessage(customId, content);
        return;
      }
      _chatRepository.sendMessage(
        SendChatMessageCommand(
          username: _username,
          content: content,
          avatarId: _outgoingAvatars.avatarId,
          avatarUrl: _outgoingAvatars.avatarUrlForSocket,
        ),
      );
    });
  }

  void _onHorizontalShake(ChatHorizontalShakeDetected event) {
    final index = _panelStateRepository.selectedEmojiIndex.value;
    if (index >= 0 && index < ChatConstants.defaultEmojis.length) {
      final emoji = ChatConstants.defaultEmojis[index];
      final activeChannelId =
          _panelStateRepository.activeCustomChannelId.value;
      if (activeChannelId != null) {
        _canalsRepository.sendEmoji(activeChannelId, emoji);
      } else {
        _chatRepository.sendEmoji(
          SendChatEmojiCommand(username: _username, emoji: emoji),
        );
      }
    }
  }
}

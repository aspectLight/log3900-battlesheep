import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../../discussion_canals/domain/interfaces/discussion_canals_repository.dart';
import '../../../../discussion_canals/domain/models/channel_message.dart';

class SlidingChatBoxViewModel {
  SlidingChatBoxViewModel({
    required DiscussionCanalsRepository canalsRepository,
  }) : _canalsRepository = canalsRepository {
    _joinedSub = canalsRepository.joinedChannelsUpdated.listen((ids) {
      joinedChannelIds.value = ids;
      if (activeChannelId.value != null &&
          !ids.contains(activeChannelId.value)) {
        activeChannelId.value = null;
      }
    });
    _messagesSub = canalsRepository.messagesUpdated.listen((e) {
      if (activeChannelId.value == e.channelId) {
        activeChannelMessages.value = e.messages;
      }
    });
  }

  final DiscussionCanalsRepository _canalsRepository;
  StreamSubscription<List<String>>? _joinedSub;
  StreamSubscription<MessagesUpdatedEvent>? _messagesSub;

  final Signal<bool> isExpanded = signal(false);
  final Signal<List<String>> joinedChannelIds = signal([]);
  final Signal<String?> activeChannelId = signal(null);
  final Signal<List<ChannelMessage>> activeChannelMessages = signal([]);
  final Signal<Map<String, String>> channelNames = signal({});

  void toggleExpanded() => isExpanded.value = !isExpanded.value;

  void setActiveChannel(String? channelId) {
    activeChannelId.value = channelId;
    if (channelId != null) {
      activeChannelMessages.value = _canalsRepository.getMessages(channelId);
    }
  }

  void sendChannelMessage(String content) {
    final id = activeChannelId.value;
    if (id == null || content.trim().isEmpty) return;
    _canalsRepository.sendMessage(id, content);
  }

  String resolveChannelName(String channelId) {
    return channelNames.value[channelId] ?? channelId;
  }

  void dispose() {
    unawaited(_joinedSub?.cancel());
    unawaited(_messagesSub?.cancel());
  }
}

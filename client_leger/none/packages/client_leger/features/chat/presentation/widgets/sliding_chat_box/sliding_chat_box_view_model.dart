import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../data/models/channel_info.dart';
import '../../../data/models/channel_message.dart';
import '../../../data/repositories/discussion_canals_repository.dart';

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
    _channelsListSub = canalsRepository.channelsUpdated.listen((list) {
      channels.value = list;
      isChannelsLoading.value = false;
    });
    _channelCreatedSub = canalsRepository.channelCreated.listen((name) {
      _showSuccess('Canal "$name" créé avec succès !');
    });
    _channelDeletedSub = canalsRepository.channelDeleted.listen((_) {
      _showSuccess('Canal supprimé.');
    });
    _channelErrorSub = canalsRepository.channelError.listen(_showError);
  }

  final DiscussionCanalsRepository _canalsRepository;

  StreamSubscription<List<String>>? _joinedSub;
  StreamSubscription<MessagesUpdatedEvent>? _messagesSub;
  StreamSubscription<List<ChannelInfo>>? _channelsListSub;
  StreamSubscription<String>? _channelCreatedSub;
  StreamSubscription<void>? _channelDeletedSub;
  StreamSubscription<String>? _channelErrorSub;

  // ── Chat panel ──────────────────────────────────────────────────
  final Signal<bool> isExpanded = signal(false);
  final Signal<List<String>> joinedChannelIds = signal([]);
  final Signal<String?> activeChannelId = signal(null);
  final Signal<List<ChannelMessage>> activeChannelMessages = signal([]);
  final Signal<Map<String, String>> channelNames = signal({});

  // ── Channels panel ──────────────────────────────────────────────
  final Signal<bool> showChannelsPanel = signal(false);
  final Signal<List<ChannelInfo>> channels = signal([]);
  final Signal<bool> isChannelsLoading = signal(true);
  final Signal<String?> channelSuccessMessage = signal(null);
  final Signal<String?> channelErrorMessage = signal(null);

  String get currentUsername => _canalsRepository.currentUsername;

  // ── Chat panel methods ──────────────────────────────────────────

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
    final fromMap = channelNames.value[channelId];
    if (fromMap != null) return fromMap;
    return channels.value
        .firstWhere(
          (c) => c.id == channelId,
          orElse: () => ChannelInfo(
            id: channelId,
            name: channelId,
            creator: '',
            memberCount: 0,
          ),
        )
        .name;
  }

  // ── Channels panel methods ──────────────────────────────────────

  void toggleChannelsPanel() {
    showChannelsPanel.value = !showChannelsPanel.value;
    if (showChannelsPanel.value) {
      isChannelsLoading.value = true;
      _canalsRepository.listChannels();
    }
  }

  void createChannel(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      _showError('Le nom du canal ne peut pas être vide.');
      return;
    }
    if (trimmed.length > 50) {
      _showError('Le nom du canal ne peut pas dépasser 50 caractères.');
      return;
    }
    _canalsRepository.createChannel(trimmed);
  }

  void deleteChannel(String channelId) =>
      _canalsRepository.deleteChannel(channelId);

  void joinChannel(String channelId) =>
      _canalsRepository.joinChannel(channelId);

  void leaveChannel(String channelId) =>
      _canalsRepository.leaveChannel(channelId);

  /// Reads from [joinedChannelIds] signal — reactive inside Watch.
  bool isJoined(String channelId) => joinedChannelIds.value.contains(channelId);

  bool isCreator(ChannelInfo channel) => currentUsername == channel.creator;

  void _showSuccess(String msg) {
    channelSuccessMessage.value = msg;
    Future.delayed(
      const Duration(seconds: 3),
      () => channelSuccessMessage.value = null,
    );
  }

  void _showError(String msg) {
    channelErrorMessage.value = msg;
    Future.delayed(
      const Duration(seconds: 4),
      () => channelErrorMessage.value = null,
    );
  }

  void dispose() {
    unawaited(_joinedSub?.cancel());
    unawaited(_messagesSub?.cancel());
    unawaited(_channelsListSub?.cancel());
    unawaited(_channelCreatedSub?.cancel());
    unawaited(_channelDeletedSub?.cancel());
    unawaited(_channelErrorSub?.cancel());
  }
}

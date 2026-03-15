import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../core/app_transition/discussion_canals_events.dart';
import '../../domain/interfaces/discussion_canals_repository.dart';
import '../../domain/models/channel_info.dart';
import '../../domain/models/channel_message.dart';

class DiscussionCanalsViewModel {
  DiscussionCanalsViewModel({
    required AppTransitionEventBus appTransitionEventBus,
    required DiscussionCanalsRepository repository,
  }) : _bus = appTransitionEventBus,
       _repository = repository {
    _initSubscriptions();
  }

  final AppTransitionEventBus _bus;
  final DiscussionCanalsRepository _repository;
  final List<StreamSubscription<dynamic>> _subs = [];

  final channels = signal<List<ChannelInfo>>([]);
  final isLoading = signal(true);
  final errorMessage = signal<String?>(null);
  final successMessage = signal<String?>(null);
  final joinedChannelIds = signal<List<String>>([]);
  final activeChannelId = signal<String?>(null);
  final channelMessages = signal<List<ChannelMessage>>([]);

  void _initSubscriptions() {
    _subs.add(
      _repository.channelsUpdated.listen((list) {
        channels.value = list;
        isLoading.value = false;
      }),
    );
    _subs.add(
      _repository.channelCreated.listen(
        (name) => _showSuccess('Canal "$name" créé avec succès !'),
      ),
    );
    _subs.add(
      _repository.channelDeleted.listen((_) => _showSuccess('Canal supprimé.')),
    );
    _subs.add(_repository.channelError.listen(_showError));
    _subs.add(
      _repository.joinedChannelsUpdated.listen(_onJoinedChannelsUpdated),
    );
    _subs.add(
      _repository.messagesUpdated.listen((e) {
        if (activeChannelId.value == e.channelId)
          channelMessages.value = e.messages;
      }),
    );
    _repository.listChannels();
  }

  void _onJoinedChannelsUpdated(List<String> ids) {
    joinedChannelIds.value = ids;
    final current = activeChannelId.value;
    if (current == null && ids.isNotEmpty) {
      setActiveChannel(ids.first);
    } else if (current != null && !ids.contains(current)) {
      activeChannelId.value = ids.isEmpty ? null : ids.first;
      channelMessages.value = ids.isEmpty
          ? []
          : _repository.getMessages(ids.first);
    }
  }

  void dispose() {
    for (final sub in _subs) {
      unawaited(sub.cancel());
    }
  }

  void requestLeave() =>
      _bus.fire(const DiscussionCanalsExitAppEvent.leaveRequested());

  void createChannel(String name) {
    if (name.isEmpty) {
      _showError('Le nom du canal ne peut pas être vide.');
      return;
    }
    if (name.length > 50) {
      _showError('Le nom du canal ne peut pas dépasser 50 caractères.');
      return;
    }
    errorMessage.value = null;
    _repository.createChannel(name);
  }

  void deleteChannel(String channelId) => _repository.deleteChannel(channelId);
  void joinChannel(String channelId) => _repository.joinChannel(channelId);
  void leaveChannel(String channelId) => _repository.leaveChannel(channelId);
  void sendMessage(String channelId, String content) {
    if (content.isNotEmpty) _repository.sendMessage(channelId, content);
  }

  void setActiveChannel(String channelId) {
    activeChannelId.value = channelId;
    channelMessages.value = _repository.getMessages(channelId);
  }

  bool isJoined(String channelId) => _repository.isJoined(channelId);
  bool isCreator(ChannelInfo channel) =>
      _repository.currentUsername == channel.creator;

  String getChannelName(String channelId) {
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

  void _showSuccess(String msg) {
    successMessage.value = msg;
    Future.delayed(
      const Duration(seconds: 3),
      () => successMessage.value = null,
    );
  }

  void _showError(String msg) {
    errorMessage.value = msg;
    Future.delayed(const Duration(seconds: 4), () => errorMessage.value = null);
  }
}

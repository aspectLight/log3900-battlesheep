import 'dart:async';

import '../../../../../core/services/socket_service.dart';
import '../../core/constants/discussion_canals_events.dart';
import '../models/channel_info.dart';
import '../models/channel_message.dart';
import 'discussion_canals_repository.dart';

class DiscussionCanalsSocket implements DiscussionCanalsRepository {
  DiscussionCanalsSocket({
    required SocketService socketService,
    required String username,
  }) : _socketService = socketService,
       _username = username {
    if (socketService.isConnected) _setupListeners();
    _connectionSub = socketService.connectionStream.listen((connected) {
      if (connected) _setupListeners();
    });
  }

  final SocketService _socketService;
  final String _username;

  final _channelsController = StreamController<List<ChannelInfo>>.broadcast();
  final _channelCreatedController = StreamController<String>.broadcast();
  final _channelDeletedController = StreamController<void>.broadcast();
  final _channelErrorController = StreamController<String>.broadcast();
  final _joinedChannelsController = StreamController<List<String>>.broadcast();
  final _messagesUpdatedController =
      StreamController<MessagesUpdatedEvent>.broadcast();

  final Set<String> _joinedIds = {};
  final Map<String, List<ChannelMessage>> _messagesByChannel = {};

  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<Object?>? _listSub;
  StreamSubscription<Object?>? _createdSub;
  StreamSubscription<Object?>? _deletedSub;
  StreamSubscription<Object?>? _errorSub;
  StreamSubscription<Object?>? _joinedSub;
  StreamSubscription<Object?>? _leftSub;
  StreamSubscription<Object?>? _messageSub;
  StreamSubscription<Object?>? _messagesResponseSub;
  StreamSubscription<Object?>? _restoredSub;

  @override
  String get currentUsername => _username;

  @override
  Stream<List<ChannelInfo>> get channelsUpdated => _channelsController.stream;
  @override
  Stream<String> get channelCreated => _channelCreatedController.stream;
  @override
  Stream<void> get channelDeleted => _channelDeletedController.stream;
  @override
  Stream<String> get channelError => _channelErrorController.stream;
  @override
  Stream<List<String>> get joinedChannelsUpdated =>
      _joinedChannelsController.stream;
  @override
  Stream<MessagesUpdatedEvent> get messagesUpdated =>
      _messagesUpdatedController.stream;

  void _setupListeners() {
    _cancelEventSubs();
    _listSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.customChannelsListResponse)
        .listen(_onChannelsList);
    _createdSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.customChannelCreated)
        .listen(_onChannelCreated);
    _deletedSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.customChannelDeleted)
        .listen(_onChannelDeleted);
    _errorSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.customChannelError)
        .listen(_onChannelError);
    _joinedSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.customChannelJoined)
        .listen(_onChannelJoined);
    _leftSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.customChannelLeft)
        .listen(_onChannelLeft);
    _messageSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.customChannelMessage)
        .listen(_onChannelMessage);
    _messagesResponseSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.customChannelMessagesResponse)
        .listen(_onMessagesResponse);
    _restoredSub = _socketService
        .on<Object?>(DiscussionCanalsSocketEvents.userChannelsRestored)
        .listen(_onUserChannelsRestored);
  }

  void _onChannelsList(Object? raw) {
    final list = raw as List<dynamic>;
    final channels = list.map((e) {
      final m = e as Map<String, dynamic>;
      return ChannelInfo(
        id: m['id'] as String,
        name: m['name'] as String,
        creator: m['creator'] as String,
        memberCount: m['memberCount'] as int,
      );
    }).toList();
    _channelsController.add(channels);
  }

  void _onChannelCreated(Object? raw) {
    final m = raw as Map<String, dynamic>;
    _channelCreatedController.add(m['channelName'] as String);
  }

  void _onChannelDeleted(Object? raw) {
    final m = raw as Map<String, dynamic>;
    final channelId = m['channelId'] as String;
    _joinedIds.remove(channelId);
    _messagesByChannel.remove(channelId);
    _channelDeletedController.add(null);
    _joinedChannelsController.add([..._joinedIds]);
  }

  void _onChannelError(Object? raw) {
    final m = raw as Map<String, dynamic>;
    _channelErrorController.add(m['message'] as String);
  }

  void _onChannelJoined(Object? raw) {
    final m = raw as Map<String, dynamic>;
    final channelId = m['channelId'] as String;
    _joinedIds.add(channelId);
    _joinedChannelsController.add([..._joinedIds]);
  }

  void _onChannelLeft(Object? raw) {
    final m = raw as Map<String, dynamic>;
    _joinedIds.remove(m['channelId'] as String);
    _joinedChannelsController.add([..._joinedIds]);
  }

  void _onChannelMessage(Object? raw) {
    final m = raw as Map<String, dynamic>;
    final channelId = m['channelId'] as String;
    final msg = _parseMessage(m['message'] as Map<String, dynamic>);
    _messagesByChannel[channelId] = [
      ...(_messagesByChannel[channelId] ?? []),
      msg,
    ];
    _messagesUpdatedController.add(
      MessagesUpdatedEvent(
        channelId: channelId,
        messages: _messagesByChannel[channelId]!,
      ),
    );
  }

  void _onMessagesResponse(Object? raw) {
    final m = raw as Map<String, dynamic>;
    final channelId = m['channelId'] as String;
    final messages = (m['messages'] as List<dynamic>)
        .map((e) => _parseMessage(e as Map<String, dynamic>))
        .toList();
    _messagesByChannel[channelId] = messages;
    _messagesUpdatedController.add(
      MessagesUpdatedEvent(channelId: channelId, messages: messages),
    );
  }

  void _onUserChannelsRestored(Object? raw) {
    final list = raw as List<dynamic>;
    for (final e in list) {
      final m = e as Map<String, dynamic>;
      final channelId = m['channelId'] as String;
      _joinedIds.add(channelId);
      _socketService.emit(
        DiscussionCanalsSocketEvents.getCustomChannelMessages,
        {'channelId': channelId},
      );
    }
    _joinedChannelsController.add([..._joinedIds]);
  }

  ChannelMessage _parseMessage(Map<String, dynamic> m) {
    return ChannelMessage(
      channelId: '',
      senderName: m['name'] as String? ?? '',
      content: m['content'] as String? ?? '',
      time: m['time'] as String? ?? '',
      avatarId: m['avatarId'] as String?,
      avatarUrl: m['avatarUrl'] as String?,
    );
  }

  @override
  void listChannels() =>
      _socketService.emit(DiscussionCanalsSocketEvents.listCustomChannels);

  @override
  void createChannel(String name) => _socketService.emit(
    DiscussionCanalsSocketEvents.createCustomChannel,
    {'channelName': name, 'username': _username},
  );

  @override
  void deleteChannel(String channelId) => _socketService.emit(
    DiscussionCanalsSocketEvents.deleteCustomChannel,
    {'channelId': channelId, 'username': _username},
  );

  @override
  void joinChannel(String channelId) => _socketService.emit(
    DiscussionCanalsSocketEvents.joinCustomChannel,
    {'channelId': channelId, 'username': _username},
  );

  @override
  void leaveChannel(String channelId) => _socketService.emit(
    DiscussionCanalsSocketEvents.leaveCustomChannel,
    {'channelId': channelId, 'username': _username},
  );

  @override
  void sendMessage(String channelId, String content) => _socketService.emit(
    DiscussionCanalsSocketEvents.sendMessageToCustomChannel,
    {'channelId': channelId, 'username': _username, 'message': content},
  );

  @override
  List<ChannelMessage> getMessages(String channelId) =>
      _messagesByChannel[channelId] ?? [];

  @override
  bool isJoined(String channelId) => _joinedIds.contains(channelId);

  void _cancelEventSubs() {
    unawaited(_listSub?.cancel());
    unawaited(_createdSub?.cancel());
    unawaited(_deletedSub?.cancel());
    unawaited(_errorSub?.cancel());
    unawaited(_joinedSub?.cancel());
    unawaited(_leftSub?.cancel());
    unawaited(_messageSub?.cancel());
    unawaited(_messagesResponseSub?.cancel());
    unawaited(_restoredSub?.cancel());
  }

  Future<void> dispose() async {
    await _connectionSub?.cancel();
    _cancelEventSubs();
    await _channelsController.close();
    await _channelCreatedController.close();
    await _channelDeletedController.close();
    await _channelErrorController.close();
    await _joinedChannelsController.close();
    await _messagesUpdatedController.close();
  }
}

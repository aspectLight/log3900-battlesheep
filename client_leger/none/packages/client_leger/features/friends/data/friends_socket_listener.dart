import 'dart:async';

import '../../../core/services/socket_service.dart';
import '../core/constants/social_socket_events.dart';
import '../presentation/screens/friends_view_model.dart';

Map<String, dynamic>? _asStringKeyMap(Object? raw) {
  if (raw is! Map) return null;
  return Map<String, dynamic>.from(raw);
}

class FriendsSocketListener {
  FriendsSocketListener({
    required SocketService socketService,
    required FriendsViewModel viewModel,
  }) : _socketService = socketService,
       _viewModel = viewModel {
    if (socketService.isConnected) _setupListeners();
    _connectionSub = socketService.connectionStream.listen((connected) {
      if (connected) _setupListeners();
    });
  }

  final SocketService _socketService;
  final FriendsViewModel _viewModel;
  StreamSubscription<bool>? _connectionSub;
  final List<StreamSubscription<Object?>> _subs = [];

  void _setupListeners() {
    for (final s in _subs) {
      unawaited(s.cancel());
    }
    _subs.clear();
    _subs.addAll([
      _socketService
          .on<Object?>(SocialSocketEvents.friendRequestReceived)
          .listen((_) => _viewModel.reloadPendingRequests()),
      _socketService
          .on<Object?>(SocialSocketEvents.friendRequestAccepted)
          .listen((_) {
            unawaited(_viewModel.reloadFriends());
            unawaited(_viewModel.reloadSentRequests());
          }),
      _socketService
          .on<Object?>(SocialSocketEvents.friendRequestRefused)
          .listen((_) => _viewModel.reloadSentRequests()),
      _socketService
          .on<Object?>(SocialSocketEvents.friendRequestCanceled)
          .listen((_) => _viewModel.reloadPendingRequests()),
      _socketService
          .on<Object?>(SocialSocketEvents.friendRemoved)
          .listen((_) => _viewModel.reloadFriends()),
      _socketService.on<Object?>(SocialSocketEvents.friendOnline).listen((raw) {
        final m = _asStringKeyMap(raw);
        if (m == null) return;
        final username = m['username'] as String?;
        if (username == null) return;
        _viewModel.updateFriendPresence(username, isOnline: true);
      }),
      _socketService.on<Object?>(SocialSocketEvents.friendOffline).listen((
        raw,
      ) {
        final m = _asStringKeyMap(raw);
        if (m == null) return;
        final username = m['username'] as String?;
        if (username == null) return;
        _viewModel.updateFriendPresence(username, isOnline: false);
      }),
    ]);
  }

  Future<void> dispose() async {
    await _connectionSub?.cancel();
    for (final s in _subs) {
      unawaited(s.cancel());
    }
  }
}

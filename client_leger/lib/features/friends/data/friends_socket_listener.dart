import 'dart:async';

import '../../../core/services/log_service.dart';
import '../../../core/services/socket_service.dart';
import '../core/constants/social_socket_events.dart';
import '../domain/models/friend_profile.dart';
import '../domain/models/friend_request.dart';
import '../presentation/screens/friends_view_model.dart';

Map<String, dynamic>? _toStringKeyMap(Object? raw) {
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
    LogService.i(
      'FriendsSocketListener initialized and listening to socket events',
    );
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
      _socketService.on<Object?>(SocialSocketEvents.friendsListResponse).listen(
        (raw) {
          if (raw is! List) return;
          final list = raw
              .whereType<Map>()
              .map((e) => FriendProfile.fromJson(Map<String, dynamic>.from(e)))
              .toList();
          _viewModel.setFriends(list);
        },
      ),

      _socketService
          .on<Object?>(SocialSocketEvents.pendingRequestsResponse)
          .listen((raw) {
            if (raw is! List) return;
            final list = raw
                .whereType<Map>()
                .map(
                  (e) => FriendRequest.fromJson(Map<String, dynamic>.from(e)),
                )
                .toList();
            _viewModel.setPendingRequests(list);
          }),

      _socketService
          .on<Object?>(SocialSocketEvents.blockedUsersResponse)
          .listen((raw) {
            if (raw is! List) return;
            _viewModel.setBlockedUsers(raw.whereType<String>().toList());
          }),

      _socketService
          .on<Object?>(SocialSocketEvents.usersWhoBlockedMeResponse)
          .listen((raw) {
            if (raw is! List) return;
            _viewModel.setUsersWhoBlockedMe(raw.whereType<String>().toList());
          }),

      _socketService
          .on<Object?>(SocialSocketEvents.friendRequestReceived)
          .listen((_) {
            unawaited(_viewModel.reloadPendingRequests());
          }),

      _socketService
          .on<Object?>(SocialSocketEvents.friendRequestAccepted)
          .listen((raw) {
            unawaited(_viewModel.reloadFriends());
            unawaited(_viewModel.reloadSentRequests());
          }),

      _socketService
          .on<Object?>(SocialSocketEvents.friendRequestRefused)
          .listen((raw) {
            unawaited(_viewModel.reloadSentRequests());
          }),

      _socketService
          .on<Object?>(SocialSocketEvents.friendRequestCanceled)
          .listen((_) {
            _socketService.emit(SocialSocketEvents.getPendingRequests);
          }),

      _socketService.on<Object?>(SocialSocketEvents.friendRemoved).listen((
        raw,
      ) {
        if (raw is Map) {
          final data = raw as Map<String, dynamic>;
          final username = data['friendUsername'] as String?;
          if (username != null) {
            _viewModel.setFriends(
              _viewModel.friends.value
                  .where((f) => f.username != username)
                  .toList(),
            );
          }
        }
      }),

      _socketService.on<Object?>(SocialSocketEvents.userBlocked).listen((raw) {
        final m = _toStringKeyMap(raw);
        if (m == null) return;
        final blocker = m['blockerUsername'] as String?;
        if (blocker == null) return;
        final current = List<String>.from(_viewModel.usersWhoBlockedMe.value);
        if (!current.contains(blocker)) {
          _viewModel.setUsersWhoBlockedMe([...current, blocker]);
        }
      }),

      _socketService.on<Object?>(SocialSocketEvents.userUnblocked).listen((
        raw,
      ) {
        final m = _toStringKeyMap(raw);
        if (m == null) return;
        final unblocker = m['unblockerUsername'] as String?;
        if (unblocker == null) return;
        _viewModel.setUsersWhoBlockedMe(
          _viewModel.usersWhoBlockedMe.value
              .where((u) => u != unblocker)
              .toList(),
        );
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

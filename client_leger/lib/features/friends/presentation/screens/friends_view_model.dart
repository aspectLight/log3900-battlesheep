import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../../../core/services/socket_service.dart';
import '../../core/app_transition/friends_events.dart';
import '../../core/constants/social_socket_events.dart';
import '../../domain/interfaces/friends_repository.dart';
import '../../domain/models/friend_profile.dart';
import '../../domain/models/friend_request.dart';
import '../../domain/models/user_search_result.dart';

enum FriendsTab { friends, requests, search, blocked }

class FriendsViewModel {
  FriendsViewModel({
    required AppTransitionEventBus appTransitionEventBus,
    required FriendsRepository repository,
    required SocketService socketService,
  }) : _bus = appTransitionEventBus,
       _repository = repository,
       _socketService = socketService;

  final AppTransitionEventBus _bus;
  final FriendsRepository _repository;
  final SocketService _socketService;

  final friends = signal<List<FriendProfile>>([]);
  final pendingRequests = signal<List<FriendRequest>>([]);
  final sentRequests = signal<List<FriendRequest>>([]);
  final blockedUsers = signal<List<String>>([]);
  final usersWhoBlockedMe = signal<List<String>>([]);
  final searchResults = signal<List<UserSearchResult>>([]);
  final isLoading = signal(true);
  final errorMessage = signal<String?>(null);
  final activeTab = signal(FriendsTab.friends);

  void requestLeave() => _bus.fire(const FriendsExitAppEvent.leaveRequested());
  Future<void> loadAll() async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      sentRequests.value = await _repository.loadSentRequests();
      _socketService.emit(SocialSocketEvents.getFriendsList);
      _socketService.emit(SocialSocketEvents.getPendingRequests);
      _socketService.emit(SocialSocketEvents.getBlockedUsers);
      _socketService.emit(SocialSocketEvents.getUsersWhoBlockedMe);
    } on Object {
      errorMessage.value = 'Erreur lors du chargement des données sociales';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reloadFriends() async {
    friends.value = await _repository.loadFriends();
  }

  Future<void> reloadPendingRequests() async {
    pendingRequests.value = await _repository.loadPendingRequests();
  }

  void setFriends(List<FriendProfile> list) => friends.value = list;

  void setPendingRequests(List<FriendRequest> list) =>
      pendingRequests.value = list;

  void setBlockedUsers(List<String> list) => blockedUsers.value = list;

  void setUsersWhoBlockedMe(List<String> list) =>
      usersWhoBlockedMe.value = list;

  Future<void> reloadSentRequests() async {
    try {
      sentRequests.value = await _repository.loadSentRequests();
    } on Object {
      // Non-critical — keep stale state
    }
  }

  void setTab(FriendsTab tab) {
    activeTab.value = tab;
    if (tab == FriendsTab.search) searchResults.value = [];
  }

  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      searchResults.value = [];
      return;
    }
    try {
      searchResults.value = await _repository.searchUsers(query);
    } on Object {
      searchResults.value = [];
    }
  }

  Future<void> sendRequest(String username) async {
    try {
      await _repository.sendFriendRequest(username);
      searchResults.value = searchResults.value
          .where((u) => u.username != username)
          .toList();
      await reloadSentRequests();
      errorMessage.value = null;
    } on Object {
      errorMessage.value = "Erreur lors de l'envoi de la demande";
    }
  }

  Future<void> acceptRequest(String requestId) async {
    try {
      await _repository.acceptFriendRequest(requestId);
      await Future.wait([reloadFriends(), reloadPendingRequests()]);
      errorMessage.value = null;
    } on Object {
      errorMessage.value = "Erreur lors de l'acceptation de la demande";
    }
  }

  Future<void> refuseRequest(String requestId) async {
    try {
      await _repository.refuseFriendRequest(requestId);
      await reloadPendingRequests();
      errorMessage.value = null;
    } on Object {
      errorMessage.value = 'Erreur lors du refus de la demande';
    }
  }

  Future<void> cancelRequest(String requestId) async {
    try {
      await _repository.cancelFriendRequest(requestId);
      await reloadSentRequests();
      errorMessage.value = null;
    } on Object {
      errorMessage.value = "Erreur lors de l'annulation de la demande";
    }
  }

  Future<void> cancelRequestByUsername(String username) async {
    final req = sentRequests.value
        .where((r) => r.receiverId == username)
        .firstOrNull;
    if (req != null) await cancelRequest(req.id);
  }

  void removeFriend(String username) {
    _socketService.emit(SocialSocketEvents.removeFriend, <String, String>{
      'friendUsername': username,
    });
    errorMessage.value = null;
  }

  void blockUser(String username) {
    _socketService.emit(SocialSocketEvents.blockUser, <String, String>{
      'targetUsername': username,
    });
    _socketService.emit(SocialSocketEvents.getBlockedUsers);
    errorMessage.value = null;
  }

  void blockUserFromSearch(String username) {
    blockUser(username);
    searchResults.value = searchResults.value
        .where((u) => u.username != username)
        .toList();
  }

  void unblockUser(String username) {
    _socketService.emit(SocialSocketEvents.unblockUser, <String, String>{
      'targetUsername': username,
    });
    _socketService.emit(SocialSocketEvents.getBlockedUsers);
    errorMessage.value = null;
  }

  bool hasPendingRequestTo(String username) =>
      sentRequests.value.any((r) => r.receiverId == username);

  bool isBlocked(String username) => blockedUsers.value.contains(username);
}

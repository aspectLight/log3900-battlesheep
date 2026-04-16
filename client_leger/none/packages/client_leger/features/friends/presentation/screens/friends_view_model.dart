import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../../../core/app_transition/app_transition_bus.dart';
import '../../core/app_transition/friends_events.dart';
import '../../domain/interfaces/friends_repository.dart';
import '../../domain/models/friend_profile.dart';
import '../../domain/models/friend_request.dart';
import '../../domain/models/user_search_result.dart';

enum FriendsTab { friends, requests, search, blocked }

class FriendsViewModel {
  FriendsViewModel({
    required AppTransitionEventBus appTransitionEventBus,
    required FriendsRepository repository,
  }) : _bus = appTransitionEventBus,
       _repository = repository;

  final AppTransitionEventBus _bus;
  final FriendsRepository _repository;

  final friends = signal<List<FriendProfile>>([]);
  final pendingRequests = signal<List<FriendRequest>>([]);
  final sentRequests = signal<List<FriendRequest>>([]);
  final blockedUsers = signal<List<String>>([]);
  final searchResults = signal<List<UserSearchResult>>([]);
  final isLoading = signal(true);
  final errorMessage = signal<String?>(null);
  final activeTab = signal(FriendsTab.friends);

  void requestLeave() => _bus.fire(const FriendsExitAppEvent.leaveRequested());

  Future<void> loadAll() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _repository.loadFriends(),
        _repository.loadPendingRequests(),
        _repository.loadSentRequests(),
        _repository.loadBlockedUsers(),
      ]);
      friends.value = results[0] as List<FriendProfile>;
      pendingRequests.value = results[1] as List<FriendRequest>;
      sentRequests.value = results[2] as List<FriendRequest>;
      blockedUsers.value = results[3] as List<String>;
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

  Future<void> reloadSentRequests() async {
    sentRequests.value = await _repository.loadSentRequests();
  }

  void updateFriendPresence(String username, {required bool isOnline}) {
    friends.value = friends.value
        .map((f) => f.username == username ? f.copyWith(isOnline: isOnline) : f)
        .toList();
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

  Future<void> removeFriend(String username) async {
    try {
      await _repository.removeFriend(username);
      await reloadFriends();
      errorMessage.value = null;
    } on Object {
      errorMessage.value = "Erreur lors de la suppression de l'ami";
    }
  }

  Future<void> blockUser(String username) async {
    try {
      await _repository.blockUser(username);
      await Future.wait([reloadFriends(), _reloadBlockedUsers()]);
      errorMessage.value = null;
    } on Object {
      errorMessage.value = "Erreur lors du blocage de l'utilisateur";
    }
  }

  Future<void> blockUserFromSearch(String username) async {
    await blockUser(username);
    searchResults.value = searchResults.value
        .where((u) => u.username != username)
        .toList();
  }

  Future<void> unblockUser(String username) async {
    try {
      await _repository.unblockUser(username);
      await _reloadBlockedUsers();
      errorMessage.value = null;
    } on Object {
      errorMessage.value = "Erreur lors du déblocage de l'utilisateur";
    }
  }

  Future<void> _reloadBlockedUsers() async {
    blockedUsers.value = await _repository.loadBlockedUsers();
  }

  bool hasPendingRequestTo(String username) =>
      sentRequests.value.any((r) => r.receiverId == username);
  bool isBlocked(String username) => blockedUsers.value.contains(username);
}

import '../models/friend_profile.dart';
import '../models/friend_request.dart';
import '../models/user_search_result.dart';

abstract interface class FriendsRepository {
  Future<List<FriendProfile>> loadFriends();
  Future<List<FriendRequest>> loadPendingRequests();
  Future<List<FriendRequest>> loadSentRequests();
  Future<List<String>> loadBlockedUsers();
  Future<List<String>> loadUsersWhoBlockedMe();
  Future<List<UserSearchResult>> searchUsers(String query);
  Future<void> sendFriendRequest(String targetUsername);
  Future<void> acceptFriendRequest(String requestId);
  Future<void> refuseFriendRequest(String requestId);
  Future<void> cancelFriendRequest(String requestId);
  Future<void> removeFriend(String username);
  Future<void> blockUser(String targetUsername);
  Future<void> unblockUser(String username);
}

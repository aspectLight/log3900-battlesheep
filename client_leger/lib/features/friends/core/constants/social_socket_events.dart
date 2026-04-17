abstract final class SocialSocketEvents {
  static const String sendFriendRequest = 'sendFriendRequest';
  static const String acceptFriendRequest = 'acceptFriendRequest';
  static const String refuseFriendRequest = 'refuseFriendRequest';
  static const String cancelFriendRequest = 'cancelFriendRequest';
  static const String removeFriend = 'removeFriend';
  static const String blockUser = 'blockUser';
  static const String unblockUser = 'unblockUser';
  static const String getFriendsList = 'getFriendsList';
  static const String getPendingRequests = 'getPendingRequests';
  static const String getBlockedUsers = 'getBlockedUsers';
  static const String getUsersWhoBlockedMe = 'getUsersWhoBlockedMe';
  static const String friendsListResponse = 'friendsListResponse';
  static const String pendingRequestsResponse = 'pendingRequestsResponse';
  static const String blockedUsersResponse = 'blockedUsersResponse';
  static const String usersWhoBlockedMeResponse = 'usersWhoBlockedMeResponse';
  static const String friendRequestReceived = 'friendRequestReceived';
  static const String friendRequestAccepted = 'friendRequestAccepted';
  static const String friendRequestRefused = 'friendRequestRefused';
  static const String friendRequestCanceled = 'friendRequestCanceled';
  static const String friendRemoved = 'friendRemoved';
  static const String userBlocked = 'userBlocked';
  static const String userUnblocked = 'userUnblocked';
  static const String friendOnline = 'friendOnline';
  static const String friendOffline = 'friendOffline';
  static const String socialError = 'socialError';
}

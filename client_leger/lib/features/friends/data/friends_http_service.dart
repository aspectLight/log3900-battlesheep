import 'package:dio/dio.dart';

import '../../../features/authentication/core/interfaces/auth_repository.dart';
import '../domain/interfaces/friends_repository.dart';
import '../domain/models/friend_profile.dart';
import '../domain/models/friend_request.dart';
import '../domain/models/user_search_result.dart';

class FriendsHttpService implements FriendsRepository {
  FriendsHttpService({required Dio dio, required AuthRepository authRepository})
    : _dio = dio,
      _authRepository = authRepository;

  final Dio _dio;
  final AuthRepository _authRepository;

  static const String _base = '/social';

  Options _authOptions() {
    final creds = _authRepository.getSocketAuthCredentials();
    return creds.match(
      () => Options(),
      (c) => Options(
        headers: {
          'Authorization': 'Bearer ${c.token}',
          'x-session-id': c.sessionId,
        },
      ),
    );
  }

  @override
  Future<List<FriendProfile>> loadFriends() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/friends',
      options: _authOptions(),
    );
    return (res.data ?? [])
        .map((e) => FriendProfile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FriendRequest>> loadPendingRequests() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/requests/pending',
      options: _authOptions(),
    );
    return (res.data ?? [])
        .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FriendRequest>> loadSentRequests() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/requests/sent',
      options: _authOptions(),
    );
    return (res.data ?? [])
        .map((e) => FriendRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<String>> loadBlockedUsers() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/blocked',
      options: _authOptions(),
    );
    return (res.data ?? []).map((e) => e as String).toList();
  }

  @override
  Future<List<String>> loadUsersWhoBlockedMe() async {
    final res = await _dio.get<List<dynamic>>(
      '$_base/blocked-by',
      options: _authOptions(),
    );
    return (res.data ?? []).map((e) => e as String).toList();
  }

  @override
  Future<List<UserSearchResult>> searchUsers(String query) async {
    if (query.trim().isEmpty) return [];
    final res = await _dio.get<List<dynamic>>(
      '$_base/search',
      queryParameters: {'q': query},
      options: _authOptions(),
    );
    return (res.data ?? [])
        .map((e) => UserSearchResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> sendFriendRequest(String targetUsername) async {
    await _dio.post<void>(
      '$_base/requests',
      data: {'targetUsername': targetUsername},
      options: _authOptions(),
    );
  }

  @override
  Future<void> acceptFriendRequest(String requestId) async {
    await _dio.patch<void>(
      '$_base/requests/$requestId/accept',
      options: _authOptions(),
    );
  }

  @override
  Future<void> refuseFriendRequest(String requestId) async {
    await _dio.patch<void>(
      '$_base/requests/$requestId/refuse',
      options: _authOptions(),
    );
  }

  @override
  Future<void> cancelFriendRequest(String requestId) async {
    await _dio.delete<void>(
      '$_base/requests/$requestId',
      options: _authOptions(),
    );
  }

  @override
  Future<void> removeFriend(String username) async {
    await _dio.delete<void>(
      '$_base/friends/$username',
      options: _authOptions(),
    );
  }

  @override
  Future<void> blockUser(String targetUsername) async {
    await _dio.post<void>(
      '$_base/block',
      data: {'targetUsername': targetUsername},
      options: _authOptions(),
    );
  }

  @override
  Future<void> unblockUser(String username) async {
    await _dio.delete<void>('$_base/block/$username', options: _authOptions());
  }
}

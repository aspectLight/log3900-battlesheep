import 'dart:async';

import 'package:dio/dio.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../services/socket_service.dart';

/// Matches server `GeneralChatEvents.AvatarUpdated` / Angular `avatarUpdated`.
const String _kAvatarUpdatedSocketEvent = 'avatarUpdated';

/// Matches server `GeneralChatEvents.UsernameUpdated` / Angular `usernameUpdated`.
const String _kUsernameUpdatedSocketEvent = 'usernameUpdated';

class ChatAvatarRegistryEntry {
  const ChatAvatarRegistryEntry({
    this.avatarId,
    this.avatarRelativeUrl,
    this.deleted = false,
    this.displayNonce = 0,
  });

  final String? avatarId;
  final String? avatarRelativeUrl;
  final bool deleted;

  /// Bumped whenever this user's avatar row changes so network image widgets do not
  /// keep showing a stale bitmap for the same `/auth/avatar/...` URL.
  final int displayNonce;
}

Map<String, dynamic>? _tryJsonMap(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return null;
}

/// Username-keyed avatar snapshot for chat display (socket + HTTP batch), mirroring Angular's AvatarRegistryService.
class ChatAvatarRegistry {
  ChatAvatarRegistry({
    required SocketService socketService,
    required Dio dio,
  }) : _dio = dio {
    socketService
        .on<Object?>(_kAvatarUpdatedSocketEvent)
        .listen(_onAvatarUpdatedPayload);
    socketService
        .on<Object?>(_kUsernameUpdatedSocketEvent)
        .listen(_onUsernameUpdatedPayload);
  }

  final Dio _dio;

  final Signal<Map<String, ChatAvatarRegistryEntry>> _entries = signal({});

  final Set<String> _pendingFetch = {};
  final Set<String> _queuedForBatch = {};
  bool _batchScheduled = false;

  ReadonlySignal<Map<String, ChatAvatarRegistryEntry>> get entries =>
      _entries;

  /// Queue usernames missing from the registry; resolves with [POST /auth/avatars/batch] (same as Angular `ensureLoaded`).
  void ensureLoaded(Iterable<String?> usernames) {
    final current = _entries.value;
    for (final raw in usernames) {
      if (raw == null) continue;
      final name = raw.trim();
      if (name.isEmpty) continue;
      if (current.containsKey(name)) continue;
      if (_pendingFetch.contains(name)) continue;
      _queuedForBatch.add(name);
    }
    if (_queuedForBatch.isEmpty || _batchScheduled) return;
    _batchScheduled = true;
    scheduleMicrotask(_flushBatch);
  }

  Future<void> _flushBatch() async {
    _batchScheduled = false;
    final batch = _queuedForBatch.toList();
    _queuedForBatch.clear();
    if (batch.isEmpty) return;
    for (final u in batch) {
      _pendingFetch.add(u);
    }
    try {
      final response = await _dio.post<List<dynamic>>(
        '/auth/avatars/batch',
        data: <String, dynamic>{'usernames': batch},
      );
      final list = response.data;
      if (list != null) {
        final next = Map<String, ChatAvatarRegistryEntry>.from(_entries.value);
        for (final raw in list) {
          final m = _tryJsonMap(raw);
          if (m == null) continue;
          final username = m['username'] as String?;
          if (username == null || username.trim().isEmpty) continue;
          final key = username.trim();
          final deleted = m['deleted'] == true;
          final avatarId = m['avatarId'] as String?;
          final avatarUrl = m['avatarUrl'] as String?;
          final prev = next[key];
          final nonce = _nonceAfterUpdate(
            prev,
            avatarId: avatarId,
            avatarRelativeUrl: avatarUrl,
            deleted: deleted,
          );
          next[key] = ChatAvatarRegistryEntry(
            avatarId: avatarId,
            avatarRelativeUrl: avatarUrl,
            deleted: deleted,
            displayNonce: nonce,
          );
        }
        _entries.value = next;
      }
    } catch (_) {
      final next = Map<String, ChatAvatarRegistryEntry>.from(_entries.value);
      for (final u in batch) {
        if (!next.containsKey(u)) {
          next[u] = const ChatAvatarRegistryEntry(displayNonce: 1);
        }
      }
      _entries.value = next;
    } finally {
      for (final u in batch) {
        _pendingFetch.remove(u);
      }
    }
  }

  void setLocal(
    String username, {
    String? avatarId,
    String? avatarRelativeUrl,
  }) {
    final name = username.trim();
    if (name.isEmpty) return;
    final id = avatarId?.trim() ?? '';
    final url = avatarRelativeUrl?.trim() ?? '';
    final prev = _entries.value[name];
    // Always increment on explicit updates: custom avatar URL often stays the same
    // while the image bytes change, so we must bust [Image.network] cache.
    final nonce = (prev?.displayNonce ?? 0) + 1;
    _entries.value = {
      ..._entries.value,
      name: ChatAvatarRegistryEntry(
        avatarId: id.isEmpty ? null : id,
        avatarRelativeUrl: url.isEmpty ? null : url,
        displayNonce: nonce,
      ),
    };
  }

  void clear() {
    _entries.value = {};
    _queuedForBatch.clear();
    _pendingFetch.clear();
    _batchScheduled = false;
  }

  /// Same as the Angular avatar registry `UsernameUpdated` handler: move cached entry to the new key.
  void applyUsernameRenamed(String oldUsername, String newUsername) {
    final old = oldUsername.trim();
    final nextName = newUsername.trim();
    if (old.isEmpty || nextName.isEmpty || old == nextName) return;
    final current = _entries.value;
    final entry = current[old];
    if (entry == null) return;
    final next = Map<String, ChatAvatarRegistryEntry>.from(current);
    next[nextName] = entry;
    next.remove(old);
    _entries.value = next;
  }

  /// Prefer registry for [authorName], else message snapshot fields.
  ({
    String? avatarId,
    String? avatarUrl,
    int? avatarDisplayNonce,
  }) resolveForAuthor(
    String authorName, {
    String? messageAvatarId,
    String? messageAvatarUrl,
  }) {
    final name = authorName.trim();
    if (name.isEmpty) {
      return (
        avatarId: messageAvatarId,
        avatarUrl: messageAvatarUrl,
        avatarDisplayNonce: null,
      );
    }
    final entry = _entries.value[name];
    if (entry != null) {
      if (entry.deleted) {
        return (
          avatarId: null,
          avatarUrl: null,
          avatarDisplayNonce: entry.displayNonce,
        );
      }
      return (
        avatarId: entry.avatarId,
        avatarUrl: entry.avatarRelativeUrl,
        avatarDisplayNonce: entry.displayNonce,
      );
    }
    return (
      avatarId: messageAvatarId,
      avatarUrl: messageAvatarUrl,
      avatarDisplayNonce: null,
    );
  }

  static int _nonceAfterUpdate(
    ChatAvatarRegistryEntry? prev, {
    required String? avatarId,
    required String? avatarRelativeUrl,
    required bool deleted,
  }) {
    if (prev == null) return 1;
    if (prev.deleted != deleted ||
        prev.avatarId != avatarId ||
        prev.avatarRelativeUrl != avatarRelativeUrl) {
      return prev.displayNonce + 1;
    }
    return prev.displayNonce;
  }

  void _onAvatarUpdatedPayload(Object? raw) {
    final m = _tryJsonMap(raw);
    if (m == null) return;
    final username = m['username'] as String?;
    if (username == null || username.trim().isEmpty) return;
    final avatarId = m['avatarId'] as String?;
    final avatarUrl = m['avatarUrl'] as String?;
    setLocal(
      username.trim(),
      avatarId: avatarId,
      avatarRelativeUrl: avatarUrl,
    );
  }

  void _onUsernameUpdatedPayload(Object? raw) {
    final m = _tryJsonMap(raw);
    if (m == null) return;
    final oldName = m['oldUsername'] as String?;
    final newName = m['newUsername'] as String?;
    if (oldName == null ||
        newName == null ||
        oldName.isEmpty ||
        newName.isEmpty ||
        oldName == newName) {
      return;
    }
    applyUsernameRenamed(oldName, newName);
  }
}

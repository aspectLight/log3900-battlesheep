import '../config/env_config.dart';

/// Avatar fields attached to outgoing general and custom-channel chat messages.
/// Updated on sign-in and whenever the user profile avatar changes.
class ChatOutgoingAvatars {
  String? _avatarId;
  String? _avatarUrlForSocket;

  String? get avatarId => _avatarId;

  /// Full URL (same resolution as [EnvConfig.resolveAvatarUrl]) sent to the server.
  String? get avatarUrlForSocket => _avatarUrlForSocket;

  void setFromAvatarFields({
    required String avatarId,
    String? avatarRelativeUrl,
  }) {
    final id = avatarId.trim();
    _avatarId = id.isEmpty ? null : id;
    _avatarUrlForSocket = _resolveRelative(avatarRelativeUrl);
  }

  void clear() {
    _avatarId = null;
    _avatarUrlForSocket = null;
  }

  String? _resolveRelative(String? relative) {
    final t = relative?.trim() ?? '';
    if (t.isEmpty) return null;
    final full = EnvConfig.resolveAvatarUrl(t);
    return full.isEmpty ? null : full;
  }
}

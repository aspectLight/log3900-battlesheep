/// Normalizes profile image URLs attached to chat payloads for other clients.
///
/// The server stores URLs like `/auth/avatar/:firebaseUid?v=:avatarVersion`. If the
/// recipient requests an old `v`, the auth avatar endpoint returns 404. Sending the
/// path without `?v=` lets the server serve the current bytes with `no-cache`.
String? stripAuthAvatarVersionQueryForChatPayload(String? url) {
  final t = url?.trim();
  if (t == null || t.isEmpty) return null;
  if (!t.contains('/auth/avatar/')) return t;
  final q = t.indexOf('?');
  if (q < 0) return t;
  return t.substring(0, q);
}

/// Web clients resolve avatar URLs against their own origin. Mobile often sends
/// an absolute URL pointing at the emulator/LAN host, which breaks `<img>` on
/// desktop. For `/api/...` avatars, prefer a path-only value in player payloads.
String? normalizeProfileAvatarUrlForCrossClient(String? resolvedUrl) {
  final t = resolvedUrl?.trim();
  if (t == null || t.isEmpty) return null;
  if (t.startsWith('data:')) return t;
  if (t.startsWith('http://') || t.startsWith('https://')) {
    final u = Uri.tryParse(t);
    if (u != null && u.hasScheme && u.path.startsWith('/api/')) {
      return u.path + (u.hasQuery ? '?${u.query}' : '');
    }
  }
  return t;
}

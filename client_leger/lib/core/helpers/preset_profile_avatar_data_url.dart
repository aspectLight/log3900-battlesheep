import 'dart:convert';

import 'package:flutter/services.dart';

import '../constants/auth_avatar_assets.dart';
import '../constants/avatar_assets.dart';

/// In-memory cache: preset images are small and stable for the app lifetime.
final Map<String, String> _presetAvatarDataUrlCache = {};

/// Builds a `data:image/png;base64,...` URL from bundled preset assets so other
/// clients (e.g. Angular) can show the profile thumb via the player payload's
/// profileAvatarUrl field without shop vs account-creation lookups.
Future<String?> presetProfileAvatarDataUrlForId(String avatarId) async {
  final id = avatarId.trim();
  if (id.isEmpty) return null;

  final cached = _presetAvatarDataUrlCache[id];
  if (cached != null) return cached;

  final path = AvatarAssets.tryMiniaturePathForProfileId(id) ??
      AuthAvatarAssets.tryAssetPathForAvatarId(id);
  if (path == null) return null;

  try {
    final byteData = await rootBundle.load(path);
    final b64 = base64Encode(byteData.buffer.asUint8List());
    final dataUrl = 'data:image/png;base64,$b64';
    _presetAvatarDataUrlCache[id] = dataUrl;
    return dataUrl;
  } on Object {
    return null;
  }
}

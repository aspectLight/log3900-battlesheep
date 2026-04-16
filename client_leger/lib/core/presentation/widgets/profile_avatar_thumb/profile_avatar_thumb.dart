import 'package:flutter/material.dart';

import '../../../config/env_config.dart';
import '../../../constants/auth_avatar_assets.dart';

class ProfileAvatarThumb extends StatelessWidget {
  const ProfileAvatarThumb({
    required this.displayName,
    super.key,
    this.avatarId,
    this.avatarUrl,
    this.avatarDisplayNonce,
    this.size = 24,
    this.borderColor,
    this.backgroundColor = const Color(0xFF4a3010),
    this.textColor = const Color(0xFFffd39a),
  });

  final String displayName;
  final String? avatarId;
  final String? avatarUrl;
  final int? avatarDisplayNonce;
  final double size;
  final Color? borderColor;
  final Color backgroundColor;
  final Color textColor;

  String get _safeLabel {
    final trimmed = displayName.trim();
    if (trimmed.isEmpty) return '?';
    return String.fromCharCode(trimmed.runes.first).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final normalizedId = avatarId?.trim() ?? '';
    final normalizedUrl = avatarUrl?.trim() ?? '';
    final resolvedNetworkUrl = normalizedUrl.isEmpty
        ? ''
        : EnvConfig.resolveAvatarUrl(
            normalizedUrl,
            cacheBust: avatarDisplayNonce,
          );
    final resolvedAsset = normalizedId.isEmpty
        ? null
        : AuthAvatarAssets.assetPathForAvatarId(normalizedId);
    final hasNetwork = resolvedNetworkUrl.isNotEmpty;
    final hasAsset = resolvedAsset != null && resolvedAsset.isNotEmpty;
    final border = borderColor;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: border == null ? null : Border.all(color: border, width: 1.4),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasNetwork
          ? Image.network(
              resolvedNetworkUrl,
              fit: BoxFit.cover,
              key: ValueKey<String>(
                '$resolvedNetworkUrl|${avatarDisplayNonce ?? 0}',
              ),
              errorBuilder: (_, _, _) => _fallback(hasAsset, resolvedAsset),
            )
          : _fallback(hasAsset, resolvedAsset),
    );
  }

  Widget _fallback(bool hasAsset, String? resolvedAsset) {
    if (hasAsset) {
      return Image.asset(
        resolvedAsset!,
        key: ValueKey<String>(
          '$resolvedAsset|${avatarDisplayNonce ?? 0}',
        ),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _initial(),
      );
    }
    return _initial();
  }

  Widget _initial() {
    return ColoredBox(
      color: backgroundColor,
      child: Center(
        child: Text(
          _safeLabel,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.52,
            height: 1,
          ),
        ),
      ),
    );
  }
}

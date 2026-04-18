import 'package:fpdart/fpdart.dart';

import '../config/env_config.dart';
import 'preset_profile_avatar_data_url.dart';
import 'profile_avatar_cross_client.dart';
import '../../features/authentication/core/interfaces/auth_repository.dart';

Future<void> mergeProfileAvatarFieldsFromAuth(
  AuthRepository auth,
  Map<String, dynamic> playerPayload,
) async {
  final currentUserResult = await auth.getCurrentUser().run();
  if (currentUserResult case Left()) return;
  if (currentUserResult case Right(value: final userOption)) {
    final user = userOption.match(() => null, (u) => u);
    if (user == null) return;

    playerPayload['profileAvatarId'] = user.avatarId;
    final url = user.avatarUrl?.trim();
    if (url != null && url.isNotEmpty) {
      final absolute = url.startsWith('http://') ||
              url.startsWith('https://') ||
              url.startsWith('data:')
          ? url
          : EnvConfig.resolveAvatarUrl(url);
      final out = normalizeProfileAvatarUrlForCrossClient(
        absolute.isNotEmpty ? absolute : url,
      );
      if (out != null && out.isNotEmpty) {
        playerPayload['profileAvatarUrl'] = out;
      }
    } else {
      playerPayload.remove('profileAvatarUrl');
      // Preset-only profile: embed bundled image so web clients can use
      // [profileAvatarUrl] in <img src> without shop/account-creation lookups.
      final dataUrl = await presetProfileAvatarDataUrlForId(user.avatarId);
      if (dataUrl != null) {
        playerPayload['profileAvatarUrl'] = dataUrl;
      }
    }
  }
}

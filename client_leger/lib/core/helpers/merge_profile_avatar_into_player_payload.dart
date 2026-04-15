import 'package:fpdart/fpdart.dart';

import '../../features/authentication/core/interfaces/auth_repository.dart';

Future<void> mergeProfileAvatarFieldsFromAuth(
  AuthRepository auth,
  Map<String, dynamic> playerPayload,
) async {
  final currentUserResult = await auth.getCurrentUser().run();
  if (currentUserResult case Left()) return;
  if (currentUserResult case Right(value: final userOption)) {
    userOption.match(() {}, (user) {
      playerPayload['profileAvatarId'] = user.avatarId;
      final url = user.avatarUrl?.trim();
      if (url != null && url.isNotEmpty) {
        playerPayload['profileAvatarUrl'] = url;
      } else {
        playerPayload.remove('profileAvatarUrl');
      }
    });
  }
}

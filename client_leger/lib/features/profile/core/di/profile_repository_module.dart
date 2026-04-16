import 'package:get_it/get_it.dart';

import '../../../../core/chat/chat_outgoing_avatars.dart';
import '../../data/repositories/profile_repository.dart';
import '../../data/services/http_profile_service.dart';

void registerProfileRepositories(GetIt getIt) {
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(
      httpProfileService: getIt<HttpProfileService>(),
      chatOutgoingAvatars: getIt<ChatOutgoingAvatars>(),
    ),
  );
}

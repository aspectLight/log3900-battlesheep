import 'package:get_it/get_it.dart';

import '../interfaces/auth_repository.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/services/firebase_auth_service.dart';
import '../../data/services/http_auth_service.dart';

void registerAuthRepository(GetIt getIt) {
  getIt.registerSingletonAsync<AuthRepository>(() async {
    return AuthRepositoryImpl(
      authService: await getIt.getAsync<HttpAuthService>(),
      firebaseAuthService: getIt<FirebaseAuthService>(),
    );
  });
}

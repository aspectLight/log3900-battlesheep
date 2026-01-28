import 'package:auto_route/auto_route.dart';

import '../domain/interfaces/auth_repository.dart';
import '../generated/routing/app_router.gr.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthRepository _authRepository;

  AuthGuard({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final user = await _authRepository.currentUser;

    if (user != null) {
      resolver.next();
      return;
    }
    await resolver.redirect(const LoginRoute());
  }
}

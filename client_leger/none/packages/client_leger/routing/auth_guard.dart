import 'package:auto_route/auto_route.dart';

import '../features/authentication/core/interfaces/auth_repository.dart';
import 'app_router.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthRepository _authRepository;

  AuthGuard({required AuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final result = await _authRepository.getCurrentUser().run();
    final isAuthenticated = result.fold((l) => false, (opt) => opt.isSome());

    if (isAuthenticated) {
      resolver.next();
      return;
    }
    await resolver.redirect(const LoginRoute());
  }
}

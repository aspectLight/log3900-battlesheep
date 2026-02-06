import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/session/user_session.dart';
import '../../../domain/interfaces/repositories/auth_repository.dart';

class MainMenuViewModel {
  final UserSession _userSession;
  final AuthRepository _authRepository;

  MainMenuViewModel({
    required UserSession userSession,
    required AuthRepository authRepository,
  }) : _userSession = userSession,
       _authRepository = authRepository;

  late final username = computed(() => _userSession.currentUsername ?? '');

  Future<void> signOut() async {
    await _authRepository.signOut().run();
  }
}

import 'dart:async';

import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/auth_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/interfaces/repositories/auth_repository.dart';

class AuthViewModel {
  final AuthRepository _authRepository;
  StreamSubscription<UserEntity?>? _authSubscription;

  AuthViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    _initAuthListener();
    unawaited(checkAuthStatus());
  }

  final authState = signal<AuthState>(const AuthStateInitial());
  final isLoading = signal(false);

  late final isAuthenticated = computed(() {
    return authState.value is AuthStateAuthenticated;
  });

  late final currentUser = computed(() {
    final state = authState.value;
    if (state is AuthStateAuthenticated) {
      return state.user;
    }
    return null;
  });

  void _initAuthListener() {
    isLoading.value = true;
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      isLoading.value = false;
      if (user != null) {
        authState.value = AuthStateAuthenticated(user);
      } else {
        authState.value = const AuthStateUnauthenticated();
      }
    });
  }

  Future<void> signOut() async {
    isLoading.value = true;
    final result = await _authRepository.signOut().run();

    result.fold(
      (exception) => authState.value = AuthStateError(exception),
      (_) => authState.value = const AuthStateUnauthenticated(),
    );

    isLoading.value = false;
  }

  Future<void> checkAuthStatus() async {
    isLoading.value = true;
    final result = await _authRepository.getCurrentUser().run();

    result.fold(
      (error) => authState.value = const AuthStateUnauthenticated(),
      (option) => option.fold(
        () => authState.value = const AuthStateUnauthenticated(),
        (user) => authState.value = AuthStateAuthenticated(user),
      ),
    );
    isLoading.value = false;
  }

  void dispose() {
    unawaited(_authSubscription?.cancel());
  }
}

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/entities/auth_state.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/interfaces/repositories/auth_repository.dart';
import '../../domain/interfaces/services/socket_service.dart';
import '../config/env_config.dart';

class UserSession with WidgetsBindingObserver {
  final SocketService _socketService;
  final AuthRepository _authRepository;

  String? currentUsername;
  StreamSubscription<UserEntity?>? _authSub;

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

  UserSession({
    required SocketService socketService,
    required AuthRepository authRepository,
  }) : _socketService = socketService,
       _authRepository = authRepository {
    WidgetsBinding.instance.addObserver(this);
    _initAuthListener();
    unawaited(checkAuthStatus());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      unawaited(_authRepository.signOut().run());
    }
  }

  void _initAuthListener() {
    isLoading.value = true;
    _authSub = _authRepository.authStateChanges.listen((user) {
      isLoading.value = false;
      if (user != null) {
        currentUsername = user.username;
        authState.value = AuthStateAuthenticated(user);
        unawaited(_connect());
      } else {
        currentUsername = null;
        authState.value = const AuthStateUnauthenticated();
        _disconnect();
      }
    });
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

  Future<void> _connect() async {
    if (_socketService.isConnected) return;
    await _socketService.connect(EnvConfig.socketUrl).run();
  }

  void _disconnect() {
    _socketService.disconnect();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_authSub?.cancel());
  }
}

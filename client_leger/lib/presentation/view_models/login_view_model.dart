import 'package:signals_flutter/signals_flutter.dart';

import '../../core/enums/auth_validation_error.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/interfaces/repositories/auth_repository.dart';

class LoginViewModel {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final username = signal('');
  final password = signal('');

  final hasAttemptedSubmit = signal(false);
  final isLoading = signal(false);
  final authState = signal<AuthState>(const AuthStateInitial());

  late final usernameError = computed<AuthValidationError?>(() {
    if (username.value.isEmpty) {
      return hasAttemptedSubmit.value
          ? AuthValidationError.usernameRequired
          : null;
    }
    return null;
  });

  late final passwordError = computed<AuthValidationError?>(() {
    if (password.value.isEmpty) {
      return hasAttemptedSubmit.value
          ? AuthValidationError.passwordRequired
          : null;
    }
    return null;
  });

  late final isFormValid = computed(() {
    return username.value.isNotEmpty && password.value.isNotEmpty;
  });

  void updateUsername(String value) => username.value = value;

  void updatePassword(String value) => password.value = value;

  Future<void> submit() async {
    hasAttemptedSubmit.value = true;

    if (!isFormValid.value) {
      return;
    }

    isLoading.value = true;
    authState.value = const AuthStateLoading();

    final result = await _authRepository
        .signIn(username: username.value, password: password.value)
        .run();

    result.fold(
      (exception) => authState.value = AuthStateError(exception),
      (user) => authState.value = AuthStateAuthenticated(user),
    );

    isLoading.value = false;
  }

  void resetForm() {
    username.value = '';
    password.value = '';
    hasAttemptedSubmit.value = false;
    authState.value = const AuthStateInitial();
  }

  void dispose() {}
}

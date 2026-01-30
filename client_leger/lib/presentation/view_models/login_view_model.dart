import 'package:signals_flutter/signals_flutter.dart';

import '../../core/enums/auth_validation_error.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/interfaces/repositories/auth_repository.dart';

class LoginViewModel {
  final AuthRepository _authRepository;

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final email = signal('');
  final password = signal('');

  final hasAttemptedSubmit = signal(false);
  final isLoading = signal(false);
  final authState = signal<AuthState>(const AuthStateInitial());

  late final emailError = computed<AuthValidationError?>(() {
    if (email.value.isEmpty) {
      return hasAttemptedSubmit.value
          ? AuthValidationError.emailRequired
          : null;
    }
    if (!_emailRegex.hasMatch(email.value)) {
      return hasAttemptedSubmit.value ? AuthValidationError.invalidEmail : null;
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
    return email.value.isNotEmpty &&
        _emailRegex.hasMatch(email.value) &&
        password.value.isNotEmpty;
  });

  void updateEmail(String value) => email.value = value;

  void updatePassword(String value) => password.value = value;

  Future<void> submit() async {
    hasAttemptedSubmit.value = true;

    if (!isFormValid.value) {
      return;
    }

    isLoading.value = true;
    authState.value = const AuthStateLoading();

    final result = await _authRepository
        .signIn(identifier: email.value, password: password.value)
        .run();

    result.fold(
      (exception) => authState.value = AuthStateError(exception),
      (user) => authState.value = AuthStateAuthenticated(user),
    );

    isLoading.value = false;
  }

  void resetForm() {
    email.value = '';
    password.value = '';
    hasAttemptedSubmit.value = false;
    authState.value = const AuthStateInitial();
  }

  void dispose() {}
}

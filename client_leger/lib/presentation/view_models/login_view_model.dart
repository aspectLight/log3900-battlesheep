import 'package:signals_flutter/signals_flutter.dart';

import '../../core/enums/auth_validation_error.dart';
import '../../core/exceptions/auth_exception.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/interfaces/auth_repository.dart';

class LoginViewModel {
  final AuthRepository _authRepository;

  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final identifier = signal('');
  final password = signal('');

  final hasAttemptedSubmit = signal(false);
  final isLoading = signal(false);
  final authState = signal<AuthState>(const AuthStateInitial());

  late final identifierError = computed<AuthValidationError?>(() {
    if (identifier.value.isEmpty) {
      return hasAttemptedSubmit.value
          ? AuthValidationError.identifierRequired
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
    return identifier.value.isNotEmpty && password.value.isNotEmpty;
  });

  void updateIdentifier(String value) => identifier.value = value;

  void updatePassword(String value) => password.value = value;

  Future<void> submit() async {
    hasAttemptedSubmit.value = true;

    if (!isFormValid.value) {
      authState.value = const AuthStateError(
        UnknownAuthException('Please fill in all fields'),
      );
      return;
    }

    isLoading.value = true;
    authState.value = const AuthStateLoading();

    final result = await _authRepository
        .signIn(identifier: identifier.value, password: password.value)
        .run();

    result.fold(
      (exception) => authState.value = AuthStateError(exception),
      (user) => authState.value = AuthStateAuthenticated(user),
    );

    isLoading.value = false;
  }

  void resetForm() {
    identifier.value = '';
    password.value = '';
    hasAttemptedSubmit.value = false;
    authState.value = const AuthStateInitial();
  }

  void dispose() {
    // Clean up any resources if added in future
  }
}

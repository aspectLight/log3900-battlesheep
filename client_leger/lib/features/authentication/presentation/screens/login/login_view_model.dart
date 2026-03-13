import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/app_events/auth_events.dart';
import '../../../core/enums/auth_validation_error.dart';
import '../../../../../core/app_transition/app_transition_bus.dart';

import '../../../domain/commands/auth_commands.dart';
import '../../../domain/state/auth_state.dart';
import '../../../domain/use_cases/login_use_case.dart';
import '../../ui_models/widget_states/login_form_ui_state.dart';

class LoginViewModel {
  final LoginUseCase _loginUseCase;
  final AppTransitionEventBus _appTransitionEventBus;

  LoginViewModel({
    required LoginUseCase loginUseCase,
    required AppTransitionEventBus appTransitionEventBus,
  })  : _loginUseCase = loginUseCase,
        _appTransitionEventBus = appTransitionEventBus;

  final formState = signal<LoginFormUiState>(LoginFormUiState.initial());
  final authState = signal<AuthState>(const AuthState.initial());

  late final usernameError = computed<Option<AuthValidationError>>(() {
    final state = formState.value;
    if (state.username.isEmpty) {
      return state.hasAttemptedSubmit || state.usernameTouched
          ? const Option.of(AuthValidationError.usernameRequired)
          : const Option.none();
    }
    return const Option.none();
  });

  late final passwordError = computed<Option<AuthValidationError>>(() {
    final state = formState.value;
    if (state.password.isEmpty) {
      return state.hasAttemptedSubmit || state.passwordTouched
          ? const Option.of(AuthValidationError.passwordRequired)
          : const Option.none();
    }
    return const Option.none();
  });

  late final isFormValid = computed(() {
    final state = formState.value;
    return state.username.isNotEmpty && state.password.isNotEmpty;
  });

  void updateUsername(String value) {
    formState.value = formState.value.copyWith(username: value);
  }

  void updatePassword(String value) {
    formState.value = formState.value.copyWith(password: value);
  }

  void markUsernameTouched() {
    formState.value = formState.value.copyWith(usernameTouched: true);
  }

  void markPasswordTouched() {
    formState.value = formState.value.copyWith(passwordTouched: true);
  }

  Future<void> signInSubmit() async {
    formState.value =
        formState.value.copyWith(hasAttemptedSubmit: true);

    if (!isFormValid.value) {
      return;
    }

    authState.value = const AuthState.loading();

    final state = formState.value;
    final result = await _loginUseCase
        .execute(
          SignInCommand(
            username: state.username,
            password: state.password,
          ),
        )
        .run();

    switch (result) {
      case Left(value: final exception):
        authState.value = AuthState.error(exception);
      case Right(value: final user):
        authState.value = AuthState.authenticated(user);
        _appTransitionEventBus.fire(AuthEntryAppEvent.signInSuccess(user));
    }

  }

  void resetForm() {
    formState.value = LoginFormUiState.initial();
    authState.value = const AuthState.initial();
  }

  void dispose() {
    formState.dispose();
    authState.dispose();
    usernameError.dispose();
    passwordError.dispose();
    isFormValid.dispose();
  }
}

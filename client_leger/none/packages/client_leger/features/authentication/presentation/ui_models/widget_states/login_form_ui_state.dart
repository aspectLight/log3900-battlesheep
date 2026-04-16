import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_form_ui_state.freezed.dart';

@freezed
class LoginFormUiState with _$LoginFormUiState {
  const factory LoginFormUiState({
    required String username,
    required String password,
    required bool usernameTouched,
    required bool passwordTouched,
    required bool hasAttemptedSubmit,
  }) = _LoginFormUiState;

  factory LoginFormUiState.initial() => const LoginFormUiState(
    username: '',
    password: '',
    usernameTouched: false,
    passwordTouched: false,
    hasAttemptedSubmit: false,
  );
}

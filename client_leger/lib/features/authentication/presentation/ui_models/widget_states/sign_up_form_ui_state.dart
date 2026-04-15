import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/enums/auth_avatar.dart';

part 'sign_up_form_ui_state.freezed.dart';

@freezed
class SignUpFormUiState with _$SignUpFormUiState {
  const factory SignUpFormUiState({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
    required Option<AuthAvatar> avatar,
    String? customAvatarPath,
    required bool hasAttemptedSubmit,
  }) = _SignUpFormUiState;

  factory SignUpFormUiState.initial() => const SignUpFormUiState(
    username: '',
    email: '',
    password: '',
    confirmPassword: '',
    avatar: Option.none(),
    hasAttemptedSubmit: false,
  );
}

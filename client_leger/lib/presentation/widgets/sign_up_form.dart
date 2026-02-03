import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/constants/input_limits.dart';
import '../../generated/l10n/app_localizations.dart';
import '../view_models/sign_up_view_model.dart';
import 'auth_text_field.dart';
import 'password_text_field.dart';
import 'validation_errors.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({
    required this.viewModel,
    required this.onSubmit,
    super.key,
  });

  final SignUpViewModel viewModel;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(l10n.username),
        const SizedBox(height: 6),
        Watch(
          (context) => AuthTextField(
            label: '',
            hintText: l10n.usernamePlaceholder,
            onChanged: viewModel.updateUsername,
            enabled: !viewModel.isLoading.value,
            maxLength: InputLimits.username,
          ),
        ),
        Watch(
          (context) => ValidationErrors(errors: viewModel.usernameErrors.value),
        ),
        const SizedBox(height: 12),
        _buildLabel(l10n.email),
        const SizedBox(height: 6),
        Watch(
          (context) => AuthTextField(
            label: '',
            hintText: l10n.emailPlaceholder,
            onChanged: viewModel.updateEmail,
            enabled: !viewModel.isLoading.value,
            keyboardType: TextInputType.emailAddress,
            maxLength: InputLimits.email,
          ),
        ),
        Watch(
          (context) => ValidationErrors(errors: viewModel.emailErrors.value),
        ),
        const SizedBox(height: 12),
        _buildLabel(l10n.password),
        const SizedBox(height: 6),
        Watch(
          (context) => PasswordTextField(
            label: '',
            hintText: l10n.passwordPlaceholder,
            onChanged: viewModel.updatePassword,
            enabled: !viewModel.isLoading.value,
            maxLength: InputLimits.password,
          ),
        ),
        Watch(
          (context) => ValidationErrors(errors: viewModel.passwordErrors.value),
        ),
        const SizedBox(height: 12),
        _buildLabel(l10n.confirmPassword),
        const SizedBox(height: 6),
        Watch(
          (context) => PasswordTextField(
            label: '',
            hintText: l10n.passwordPlaceholder,
            onChanged: viewModel.updateConfirmPassword,
            enabled: !viewModel.isLoading.value,
            textInputAction: TextInputAction.done,
            onEditingComplete: onSubmit,
            maxLength: InputLimits.password,
          ),
        ),
        Watch(
          (context) =>
              ValidationErrors(errors: viewModel.confirmPasswordErrors.value),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'CustomFont',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

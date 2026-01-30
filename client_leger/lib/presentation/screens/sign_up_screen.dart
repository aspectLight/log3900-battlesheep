import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/l10n/extensions/auth_exception_ext.dart';
import '../../core/l10n/extensions/auth_validation_error_ext.dart';
import '../../domain/entities/auth_state.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../routing/app_router.dart';
import '../view_models/sign_up_view_model.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_text_field.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpViewModel _viewModel;
  EffectCleanup? _authStateCleanup;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<SignUpViewModel>();
    _setupAuthStateListener();
  }

  void _setupAuthStateListener() {
    _authStateCleanup = effect(() {
      final state = _viewModel.authState.value;

      if (state is AuthStateAuthenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          unawaited(context.router.replace(const MainRoute()));
        });
      } else if (state is AuthStateError) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final l10n = AppLocalizations.of(context)!;
          _showErrorSnackBar(state.exception.localize(l10n));
        });
      }
    });
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _authStateCleanup?.call();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [_buildHeader(), _buildForm(), _buildSwitchToLogin()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.createAccount),
        Text(AppLocalizations.of(context)!.signUpToStart),
      ],
    );
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Watch(
          (context) => AuthTextField(
            label: l10n.username,
            hintText: l10n.username,
            errorText: _viewModel.usernameError.value?.localize(l10n),
            onChanged: _viewModel.updateUsername,
            enabled: !_viewModel.isLoading.value,
          ),
        ),
        Watch(
          (context) => AuthTextField(
            label: l10n.email,
            hintText: l10n.email,
            errorText: _viewModel.emailError.value?.localize(l10n),
            onChanged: _viewModel.updateEmail,
            enabled: !_viewModel.isLoading.value,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        Watch(
          (context) => PasswordTextField(
            label: l10n.password,
            hintText: l10n.password,
            errorText: _viewModel.passwordError.value?.localize(l10n),
            onChanged: _viewModel.updatePassword,
            enabled: !_viewModel.isLoading.value,
          ),
        ),
        Watch(
          (context) => PasswordTextField(
            label: l10n.confirmPassword,
            hintText: l10n.confirmPassword,
            errorText: _viewModel.confirmPasswordError.value?.localize(l10n),
            onChanged: _viewModel.updateConfirmPassword,
            enabled: !_viewModel.isLoading.value,
            textInputAction: TextInputAction.done,
            onEditingComplete: _viewModel.submit,
          ),
        ),
        Watch(
          (context) => AuthSubmitButton(
            label: l10n.signUp,
            isLoading: _viewModel.isLoading.value,
            onPressed: _viewModel.submit,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchToLogin() {
    return Row(
      children: [
        Text(AppLocalizations.of(context)!.alreadyHaveAccount),
        TextButton(
          onPressed: () =>
              unawaited(context.router.replace(const LoginRoute())),
          child: Text(AppLocalizations.of(context)!.signIn),
        ),
      ],
    );
  }
}

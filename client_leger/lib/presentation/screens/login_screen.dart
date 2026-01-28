import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../core/l10n/extensions/auth_exception_ext.dart';
import '../../core/l10n/extensions/auth_validation_error_ext.dart';
import '../../domain/entities/auth_state.dart';
import '../../generated/l10n/app_localizations.dart';
import '../../generated/routing/app_router.gr.dart';
import '../view_models/login_view_model.dart';
import '../widgets/auth_submit_button.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/password_text_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginViewModel _viewModel;
  EffectCleanup? _authStateCleanup;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<LoginViewModel>();
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
          children: [_buildHeader(), _buildForm(), _buildSwitchToSignUp()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.welcomeBack),
        Text(AppLocalizations.of(context)!.signInToContinue),
      ],
    );
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
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
            textInputAction: TextInputAction.done,
            onEditingComplete: _viewModel.submit,
          ),
        ),
        Watch(
          (context) => AuthSubmitButton(
            label: l10n.signIn,
            isLoading: _viewModel.isLoading.value,
            onPressed: _viewModel.submit,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchToSignUp() {
    return Row(
      children: [
        Text(AppLocalizations.of(context)!.noAccount),
        TextButton(
          onPressed: () =>
              unawaited(context.router.replace(const SignUpRoute())),
          child: Text(AppLocalizations.of(context)!.signUp),
        ),
      ],
    );
  }
}

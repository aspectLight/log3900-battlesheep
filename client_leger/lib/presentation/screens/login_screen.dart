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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.gif',
              fit: BoxFit.cover,
              opacity: const AlwaysStoppedAnimation(0.5),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 350),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 32),
                    _buildForm(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.noAccount,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontFamily: 'CustomFont',
                            fontSize: 14,
                          ),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => unawaited(
                              context.router.push(const SignUpRoute()),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: const TextStyle(
                                color: Color(0xFFE34B4B),
                                fontFamily: 'CustomFont',
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFFE34B4B),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Watch(
          (context) => AuthTextField(
            label: l10n.username,
            hintText: 'JohnDoe',
            errorText: _viewModel.usernameError.value?.localize(l10n),
            onChanged: _viewModel.updateUsername,
            onFocusLost: _viewModel.markUsernameTouched,
            enabled: !_viewModel.isLoading.value,
          ),
        ),
        const SizedBox(height: 20),
        Watch(
          (context) => PasswordTextField(
            label: l10n.password,
            hintText: '••••••••',
            errorText: _viewModel.passwordError.value?.localize(l10n),
            onChanged: _viewModel.updatePassword,
            onFocusLost: _viewModel.markPasswordTouched,
            enabled: !_viewModel.isLoading.value,
            textInputAction: TextInputAction.done,
            onEditingComplete: _viewModel.submit,
          ),
        ),
        const SizedBox(height: 20),
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
}

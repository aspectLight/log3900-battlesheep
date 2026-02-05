import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/constants/asset_constants.dart';
import '../../../core/constants/input_limits.dart';
import '../../../core/l10n/extensions/auth_exception_ext.dart';
import '../../../core/l10n/extensions/auth_validation_error_ext.dart';
import '../../../domain/entities/auth_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../routing/app_router.dart';
import '../../widgets/app_background/app_background.dart';
import '../../widgets/auth_button/auth_button.dart';
import '../../widgets/auth_error_box/auth_error_box.dart';
import '../../widgets/auth_text_field/auth_text_field.dart';
import '../../widgets/password_text_field/password_text_field.dart';
import 'login_view_model.dart';

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
          unawaited(context.router.replace(const MainMenuRoute()));
        });
      }
    });
  }

  @override
  void dispose() {
    _authStateCleanup?.call();
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      AssetConstants.logo,
                      width: 450,
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
                          style: const TextStyle(
                            color: Colors.white70,
                            fontFamily: 'CustomFont',
                            fontSize: 16,
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => unawaited(
                            context.router.push(const SignUpRoute()),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 12,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.signUp,
                              style: const TextStyle(
                                color: Color(0xFFE34B4B),
                                fontFamily: 'CustomFont',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
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
          _buildBackButton(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Positioned(
      top: 40,
      left: 20,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () =>
              unawaited(context.router.replaceAll([const AuthLandingRoute()])),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.chevron_left, color: Colors.white, size: 32),
                const SizedBox(width: 4),
                Text(
                  AppLocalizations.of(context)!.back,
                  style: const TextStyle(
                    color: Color(0xFFE34B4B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'CustomFont',
                  ),
                ),
              ],
            ),
          ),
        ),
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
            hintText: l10n.usernamePlaceholder,
            errorText: _viewModel.usernameError.value?.localize(l10n),
            onChanged: _viewModel.updateUsername,
            onFocusLost: _viewModel.markUsernameTouched,
            enabled: !_viewModel.isLoading.value,
            maxLength: InputLimits.username,
          ),
        ),
        const SizedBox(height: 20),
        Watch(
          (context) => PasswordTextField(
            label: l10n.password,
            hintText: l10n.passwordPlaceholder,
            errorText: _viewModel.passwordError.value?.localize(l10n),
            onChanged: _viewModel.updatePassword,
            onFocusLost: _viewModel.markPasswordTouched,
            enabled: !_viewModel.isLoading.value,
            textInputAction: TextInputAction.done,
            onEditingComplete: _viewModel.submit,
            maxLength: InputLimits.password,
          ),
        ),
        const SizedBox(height: 20),
        Watch((context) {
          final state = _viewModel.authState.value;
          final errorMessage = state is AuthStateError
              ? state.exception.localize(l10n)
              : null;
          if (errorMessage == null) return const SizedBox.shrink();
          return Column(
            children: [
              AuthErrorBox(errorMessage: errorMessage),
              const SizedBox(height: 12),
            ],
          );
        }),
        Watch(
          (context) => AuthButton(
            label: _viewModel.isLoading.value ? l10n.signingIn : l10n.signIn,
            isLoading: _viewModel.isLoading.value,
            onPressed: _viewModel.submit,
          ),
        ),
      ],
    );
  }
}

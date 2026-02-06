import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../core/constants/asset_constants.dart';
import '../../../core/l10n/extensions/auth_exception_ext.dart';
import '../../../core/l10n/extensions/auth_validation_error_ext.dart';
import '../../../domain/entities/auth_state.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../routing/app_router.dart';
import '../../widgets/app_background/app_background.dart';
import '../../widgets/auth_button/auth_button.dart';
import '../../widgets/auth_error_box/auth_error_box.dart';
import '../../widgets/avatar_picker/avatar_picker.dart';
import '../../widgets/avatar_picker/avatar_picker_view_model.dart';
import '../../widgets/sign_up_form/sign_up_form.dart';
import 'sign_up_view_model.dart';

@RoutePage()
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final SignUpViewModel _viewModel;
  late final AvatarPickerViewModel _avatarPickerViewModel;
  EffectCleanup? _authStateCleanup;

  @override
  void initState() {
    super.initState();
    _viewModel = GetIt.I<SignUpViewModel>();
    _avatarPickerViewModel = GetIt.I<AvatarPickerViewModel>();
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
    _avatarPickerViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLogo(),
                  const SizedBox(height: 48),
                  _buildMainContainer(),
                  const SizedBox(height: 32),
                  _buildSubmitSection(),
                ],
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

  Widget _buildLogo() {
    return Image.asset(AssetConstants.logo, height: 220);
  }

  Widget _buildMainContainer() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SignUpForm(
              viewModel: _viewModel,
              onSubmit: _handleFormSubmit,
            ),
          ),
          const SizedBox(width: 64),
          SizedBox(
            width: 450,
            child: Watch(
              (context) => AvatarPicker(
                viewModel: _avatarPickerViewModel,
                onSelectionChange: _viewModel.updateAvatar,
                error: _viewModel.avatarError.value?.localize(
                  AppLocalizations.of(context)!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleFormSubmit() {
    unawaited(_viewModel.submit());
  }

  Widget _buildSubmitSection() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Watch((context) {
          final state = _viewModel.authState.value;
          final errorMessage = state is AuthStateError
              ? state.exception.localize(l10n)
              : null;
          if (errorMessage == null) return const SizedBox.shrink();
          return Column(
            children: [
              SizedBox(
                width: 450,
                child: AuthErrorBox(errorMessage: errorMessage),
              ),
              const SizedBox(height: 12),
            ],
          );
        }),
        Watch(
          (context) => SizedBox(
            width: 450,
            child: AuthButton(
              label: _viewModel.isLoading.value ? l10n.signingUp : l10n.signUp,
              isLoading: _viewModel.isLoading.value,
              onPressed: _handleFormSubmit,
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildSwitchToLogin(),
      ],
    );
  }

  Widget _buildSwitchToLogin() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.alreadyHaveAccount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'CustomFont',
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => unawaited(context.router.replace(const LoginRoute())),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            child: Text(
              l10n.signIn,
              style: const TextStyle(
                color: Color(0xFFC60D0D),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'CustomFont',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

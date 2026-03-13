import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../../core/constants/ui_assets.dart';
import '../../../core/localisation/auth_localizations.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';

import 'auth_landing_view_model.dart';

@RoutePage()
class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.I<AuthLandingViewModel>();
    final l10n = AuthLocalizations.of(context)!;
    return AppBackground(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    UiAssets.logo,
                    width: 350,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 48),
                  _buildButton(
                    context,
                    label: l10n.signIn,
                    onPressed: viewModel.goToLogin,
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    context,
                    label: l10n.createAccount,
                    onPressed: viewModel.goToSignUp,
                  ),
                ],
              ),
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 300,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: Colors.transparent),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'CustomFont',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final l10n = AuthLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          Text(
            l10n.teamName,
            style: const TextStyle(
              color: Color(0xFFB3B3B3),
              fontSize: 22,
              fontFamily: 'CustomFont',
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.teamMembers,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
              fontFamily: 'CustomFont',
            ),
          ),
        ],
      ),
    );
  }
}

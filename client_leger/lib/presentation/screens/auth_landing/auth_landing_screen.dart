import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/asset_constants.dart';
import '../../../generated/l10n/app_localizations.dart';
import '../../../routing/app_router.dart';
import '../../widgets/app_background/app_background.dart';

@RoutePage()
class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppBackground(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    AssetConstants.logo,
                    width: 350,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 48),
                  _buildButton(
                    context,
                    label: l10n.signIn,
                    onPressed: () =>
                        unawaited(context.router.push(const LoginRoute())),
                  ),
                  const SizedBox(height: 16),
                  _buildButton(
                    context,
                    label: l10n.createAccount,
                    onPressed: () =>
                        unawaited(context.router.push(const SignUpRoute())),
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
    final l10n = AppLocalizations.of(context)!;

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

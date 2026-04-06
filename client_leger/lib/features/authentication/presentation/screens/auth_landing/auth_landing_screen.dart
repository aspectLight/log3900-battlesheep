import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:signals_flutter/signals_flutter.dart';

import '../../../../../core/appearance/app_appearance_service.dart';
import '../../../../../core/constants/ui_assets.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/presentation/widgets/app_background/app_background.dart';
import '../../../core/localisation/auth_localizations.dart';
import 'auth_landing_view_model.dart';

@RoutePage()
class AuthLandingScreen extends StatelessWidget {
  const AuthLandingScreen({super.key});

  static const _languages = [('fr', '🇫🇷 Français'), ('en', '🇬🇧 English')];

  @override
  Widget build(BuildContext context) {
    final viewModel = GetIt.I<AuthLandingViewModel>();
    final l10n = AuthLocalizations.of(context)!;
    final appearance = getIt<AppAppearanceService>();

    return AppBackground(
      child: Stack(
        children: [
          Column(
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
          Positioned(
            top: 16,
            left: 16,
            child: Watch((context) {
              final current = appearance.locale.value.languageCode;
              return PopupMenuButton<String>(
                initialValue: current,
                onSelected: appearance.setLocaleLocally,
                itemBuilder: (_) => _languages
                    .map(
                      (l) => PopupMenuItem(
                        value: l.$1,
                        child: Text(
                          l.$2,
                          style: const TextStyle(fontFamily: 'CustomFont'),
                        ),
                      ),
                    )
                    .toList(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.language, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      _languages.firstWhere((l) => l.$1 == current).$2,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'CustomFont',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
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
